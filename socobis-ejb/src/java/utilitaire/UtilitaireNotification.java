/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utilitaire;

import bean.CGenUtil;
import java.sql.Connection;
//import mg.fer.paie.Absence;
//import mg.fer.paie.RetraitFraisMedicaux;

/**
 *
 * @author rakotondralambo
 */
public class UtilitaireNotification {
    private int notifTotal;
    private int notifFraisMedicaux;
    private int notifFraisCreer;
    private int notifAbsence;


    public UtilitaireNotification()throws Exception {
//        Connection c = null;
//        try{
//            c = new UtilDB().GetConn();
//            RetraitFraisMedicaux base = new RetraitFraisMedicaux();
//            base.setNomTable("retrait_frais_medicaux_lib_valide");
//            RetraitFraisMedicaux[] tabFrais = (RetraitFraisMedicaux[])CGenUtil.rechercher(base, null, null, c, "");
//            base.setNomTable("retrait_frais_medicaux_lib_cree");
//            RetraitFraisMedicaux[] tabFraisCreer = (RetraitFraisMedicaux[])CGenUtil.rechercher(base, null, null, c, "");
//            Absence lv = new Absence();
//            lv.setNomTable("absence_libvalide");
//            Absence[] tabAbs = (Absence[])CGenUtil.rechercher(lv, null, null, c, "");
//            setNotifFraisMedicaux(tabFrais.length);
//            setNotifAbsence(tabAbs.length);
//            setNotifFraisCreer(tabFraisCreer.length);
//            setNotifTotal(getNotifAbsence()+getNotifFraisMedicaux()+getNotifFraisCreer());
//        }catch(Exception e){
//            e.printStackTrace();
//            throw e;
//        }finally{
//            if(c!=null)c.close();
//        }
    }

    public int getNotifFraisCreer() {
        return notifFraisCreer;
    }

    public void setNotifFraisCreer(int notifFraisCreer) {
        this.notifFraisCreer = notifFraisCreer;
    }



    public int getNotifTotal() {
        return notifTotal;
    }

    public void setNotifTotal(int notifTotal) {
        this.notifTotal = notifTotal;
    }

    public int getNotifFraisMedicaux() {
        return notifFraisMedicaux;
    }

    public void setNotifFraisMedicaux(int notifFraisMedicaux) {
        this.notifFraisMedicaux = notifFraisMedicaux;
    }

    public int getNotifAbsence() {
        return notifAbsence;
    }

    public void setNotifAbsence(int notifAbsence) {
        this.notifAbsence = notifAbsence;
    }


}