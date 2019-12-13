#ifndef ASYMMETRICPROPAGATIONPROXY_H_
#define ASYMMETRICPROPAGATIONPROXY_H_

/** @author Stefan Unterschütz*/

/********* include files *****************************************************/
#include "ranvar.h"
#include "wireless-phy.h"
#include <map>
#include <vector>

/********* class declaration *************************************************/

/**Proxy for Propagation Models to adjust the propagation characteristic in
 * dependency of angle
 */
class AsymmetricPropagationProxy : public Propagation {
public:
	AsymmetricPropagationProxy();

	/**calculates the receiving power for an ns-2 packet.
	 *
	 * @return receving power
	 * */
	virtual double Pr(PacketStamp *t, PacketStamp *r, WirelessPhy *ifp);

	/**calculates the maximum possible radius for receiving an ns-2 packet
	 *
	 * @return maximum distance*/
	double getDist(double Pr, double Pt, double Gt, double Gr, double hr,
			double ht, double L, double lambda);

	virtual int command(int argc, const char*const* argv);

private:
	/**for random assigment of values use this default values*/
	double maxRandomGain_;
	double minRandomGain_;

	/**maximum possible gain is used for calculating the maximum possible
	 * receive limit.
	 * Never change this value after instantiation! */
	double maxGain_;

	/**number of angles fpr propagation model
	 * Never change this value after instantiation! */
	int angleNumber_;

	/**gain profile for each node */
	map<int, vector<double> > gainMap;

	/** calculating the angle etween two nodes*/
	double calcAngle(PacketStamp *t, PacketStamp *r);

	void checkPropagationModel();

	/* link to generic propagation prototyp */
	Propagation *pModel;
};

#endif /*ASYMMETRICPROPAGATIONPROXY_H_*/
