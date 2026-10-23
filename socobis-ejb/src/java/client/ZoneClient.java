package client;

import bean.ClassEtat;
import bean.TypeObjet;
import utils.ConstanteSavonnerie;

import java.sql.Connection;

public class ZoneClient extends TypeObjet {
    private double forfait, prixcarton, mincarton;

    public double getForfait() {
        return forfait;
    }

    public void setForfait(double forfait) {
        this.forfait = forfait;
    }

    public double getPrixcarton() {
        return prixcarton;
    }

    public void setPrixcarton(double prixcarton) {
        this.prixcarton = prixcarton;
    }

    public double getMincarton() {
        return mincarton;
    }

    public void setMincarton(double mincarton) {
        this.mincarton = mincarton;
    }

    public ZoneClient() throws Exception{
        this.setNomTable("ZONECLIENT");
    }


    public double calculerFraisLivraison(double nbcarton) throws Exception{
        if(nbcarton<this.mincarton){
            return (this.prixcarton*this.getMincarton());
        }
        return (this.prixcarton*nbcarton);
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ZO", "GETSEQZoneClient");
        this.setId(makePK(c));
    }

}
