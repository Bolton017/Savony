/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stock;

import java.sql.Connection;

/**
 *
 * @author Safidy
 */
public class TransfertStockDetailsAppro extends TransfertStockDetails{
    private int estapprodv;
    private double quantitesource;
    private double pusource;

    @Override
    public void controler(Connection c) throws Exception {
        if (estapprodv == 0){
            this.checkQuantiteProduit(c);
            this.checkMVTSource();
            this.controllerMvtSrc(c);
        }
    }
    public int getEstapprodv() {
        return estapprodv;
    }

    public void setEstapprodv(int estapprodv) {
        this.estapprodv = estapprodv;
    }

    public double getQuantitesource() {
        return quantitesource;
    }

    public void setQuantitesource(double quantitesource) {
        this.quantitesource = quantitesource;
    }

    public double getPusource() {
        return pusource;
    }

    public void setPusource(double pusource) {
        this.pusource = pusource;
    }
}
