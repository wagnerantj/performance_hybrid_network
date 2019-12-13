/** @author Stefan Unterschütz*/

/********* include files *****************************************************/
#include "AsymmetricPropagationProxy.h"
#include "propagation.h"
#include "packet-stamp.h"
#include <cmath>

// <-  ACTIVATE DEBUGGING MODE
//#define DEBUG

/********* namespaces ********************************************************/
using namespace std;

/********* static binding ****************************************************/

static class ClassAPPProxy : public TclClass {
public:
	ClassAPPProxy() :
		TclClass("Propagation/APProxy") {
	}
	TclObject* create(int c, const char*const* s) {
		return (new AsymmetricPropagationProxy);
	}
} class_APProxyAgent;

/********* member functions **************************************************/

int AsymmetricPropagationProxy::command(int argc, const char*const* argv) {
	Tcl &tcl = Tcl::instance();

	/* setting propagation model */
	if (strcmp(argv[1], "propagation") == 0&& argc == 3) {
		this->pModel = (Propagation*)TclObject::lookup(argv[2]);
		if (this->pModel == NULL ) {
			tcl.resultf("could not find propagation model object");
			return TCL_ERROR;
		}
		return (TCL_OK);
	}

	/* setting profile of node directly */
	if (strcmp(argv[1], "profile") == 0&& argc == 3 + angleNumber_) {
		vector<double> &profile=gainMap[atoi(argv[2])];
		int i;
		for (i = 0; i < angleNumber_ ; i++) {
			double value= atof(argv[3+i]);
			profile.push_back(value);
#ifdef DEBUG
			if (maxGain_ < value ) {
				printf("ERROR: dont use gain values larger than maxGain_\n");
			}
#endif

		}
		profile.push_back(profile[0]);

		return (TCL_OK);
	}

	return (Propagation::command(argc, argv));
}

AsymmetricPropagationProxy::AsymmetricPropagationProxy() {

#ifdef DEBUG
	printf("RUN AsymmetricPropagationProxy in DEBUGGING MODE\n");
#endif

	pModel = 0;

	bind("maxRandomGain_", &maxRandomGain_);
	bind("minRandomGain_", &minRandomGain_);
	bind("maxGain_", &maxGain_);
	bind("angleNumber_", &angleNumber_);
}

void AsymmetricPropagationProxy::checkPropagationModel() {
	if (pModel == 0) {
		printf("AsymmetricPropagationProxy: no propagtion model set\n");
	}
}

double AsymmetricPropagationProxy::Pr(PacketStamp *t, PacketStamp *r,
		WirelessPhy *ifp) {

	checkPropagationModel();

	/* if no profile exists for node create a new one*/
	if (gainMap.count(t->getNode()->nodeid()) == 0) {
		vector<double> &profile= gainMap[t->getNode()->nodeid()];
		for (int i=0; i< angleNumber_ ; i++) {
			double value = Random::uniform(minRandomGain_, maxRandomGain_);
			profile.push_back(value);
		}
		/* period continuation of vector (first one is last one)*/
		profile.push_back(profile[0]);
	}

	double x = calcAngle(t, r);

	vector<double> &profile = gainMap[t->getNode()->nodeid()];

	/* distance between too angles */
	double distance = 2*PI/(angleNumber_);

	int base= static_cast<int> (x/distance);

#ifdef DEBUG
	if (base >= angleNumber_ || base < 0) {
		printf("ERROR: wrong intervall computation\n");
	}
#endif

	double gain;

	/* linearisation in spefic intervall*/
	gain = profile[base]*((base+1)*distance-x)+profile[base+1]
			*(x-base*distance);
	gain /= (distance);

#ifdef DEBUG
	double g1, g2;
	if (profile[base] < profile[base+1]) {
		g1 = profile[base];
		g2 = profile[base+1];
	} else {
		g1 = profile[base+1];
		g2 = profile[base];
	}
	/* uses scaling 1.01 for ignoring rounding errors*/
	if (gain > g2*1.01 || gain < g1/1.01) {
		printf("ERROR: gain computation failed\n");
	}

	if (gain > maxGain_*1.01) {
		printf("ERROR: gain computation failed, larger than maxGain_\n");
	}
#endif

	t->stamp(t->getNode(), t->getAntenna(), t->getTxPr()*exp(gain),
			t->getLambda());

	return this->pModel->Pr(t, r, ifp);
}

double AsymmetricPropagationProxy::calcAngle(PacketStamp *t, PacketStamp *r) {
	double tX, tY, tZ;
	double rX, rY, rZ;
	double x, y;

	/* calculate vector  [ x y ] between nodes*/
	t->getNode()->getLoc(&tX, &tY, &tZ);
	r->getNode()->getLoc(&rX, &rY, &rZ);

	rX += r->getAntenna()->getX();
	rY += r->getAntenna()->getY();
	tX += t->getAntenna()->getX();
	tY += t->getAntenna()->getY();

	x=rX-tX;
	y=rY-tY;

	/* calculate angle of vector [ x y ]*/
	double norm=sqrt(x*x+y*y);
	double angle;
	if (y>0) {
		angle = acos(x/norm);
	} else {
		angle = 2*PI-acos(x/norm)-0.0001; // prevent from getting 2*PI
	}

#ifdef DEBUG
	if (angle < 0||angle >= 2*PI) {
		printf("ERROR: angle range %f \n", angle);
	}
#endif
	return angle;

}

double AsymmetricPropagationProxy::getDist(double Pr, double Pt, double Gt,
		double Gr, double hr, double ht, double L, double lambda) {

	checkPropagationModel();

#ifdef DEBUG
	if (maxGain_ < maxRandomGain_ ) {
		printf("ERROR: maxGain_ smaller than maxRandomGain_\n");
	}
#endif

	return this->pModel->getDist(Pr, Pt*exp(this->maxGain_), Gt, Gr, hr, ht, L,
			lambda);

}
