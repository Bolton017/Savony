package utilitaire;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


import bean.ClassEtat;
import bean.ClassMAPTable;
import java.awt.AWTException;
import java.awt.Image;
import java.awt.SystemTray;
import java.awt.Toolkit;
import java.awt.TrayIcon;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalTime;

import user.UserEJB;
import utilitaire.ConstanteEtatPaie;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

/**
 *
 * @author Flavien
 */
public class Notification extends ClassEtat {
    private String id,message,ref,receiverlib,etatlib;
    private int receiver;
    private Date daty;
    String heure;
    private String lien,ecartdate;

    public Notification(String id, String message, String ref, String receiverlib, String etatlib, int receiver,
            Date daty, String heure, String lien, String ecartdate) {
        this.id = id;
        this.message = message;
        this.ref = ref;
        this.receiverlib = receiverlib;
        this.etatlib = etatlib;
        this.receiver = receiver;
        this.daty = daty;
        this.heure = heure;
        this.lien = lien;
        this.ecartdate = ecartdate;
    }

    public String getEcartdate() {
        return ecartdate;
    }

    public void setEcartdate(String ecartdate) {
        this.ecartdate = ecartdate;
    }

    public String getLien() {
        return lien;
    }

    public void setLien(String lien) {
        this.lien = lien;
    }

    public Notification() {
        super.setNomTable("NOTIFICATION");
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getReceiverlib() {
        return receiverlib;
    }

    public void setReceiverlib(String receiverlib) {
        this.receiverlib = receiverlib;
    }

    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    public String getRef() {
        return ref;
    }

    public void setRef(String ref) {
        this.ref = ref;
    }

    public int getReceiver() {
        return receiver;
    }

    public void setReceiver(int receiver) {
        this.receiver = receiver;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }
   
    
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        preparePk("NT","getseq_notification");
        setId(makePK(c));
    }
    
    public ClassMAPTable vu(UserEJB u, Connection c)throws Exception{
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                verif = 1;
            }           
            ClassMAPTable result = (ClassMAPTable)u.validerObject(this);
            if (c != null && verif == 1) {
                c.commit();
            }
            return result;
        } catch (Exception ex) {
            if (c!=null){
                c.rollback();
            }
            throw ex;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }  
    }
    
    public ClassMAPTable vu(UserEJB u, Connection c, Notification[]notifs)throws Exception{
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                verif = 1;
            }           
            ClassMAPTable result = null;
            for(int i = 0; i<notifs.length; i++){
                result = notifs[i].vu(u, c);
            }
            
            if (c != null && verif == 1) {
                c.commit();
            }
            return result;
        } catch (Exception ex) {
            if (c!=null){
                c.rollback();
            }
            throw ex;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }  
    }

    public Notification( String message, String ref, int receiver, String lien) {
        this.message = message;
        this.ref = ref;
        this.receiver = receiver;
        this.lien = lien;
    }
    public void creerNotification(int receiver,String message,String ref,String lien,Connection con) throws Exception{
        if(con==null){
            con = (new UtilDB()).GetConn();
        }

        Notification n = new Notification();
        n.setNomTable("notification");
        n.setRef(ref);
        n.setReceiver(receiver);
        n.setLien(lien);
        n.setMessage(message);
        n.setDaty(Utilitaire.dateDuJourSql());
        n.setHeure(Utilitaire.heureCouranteHMS());
        n.setEtat(ConstanteEtatPaie.getEtatCreer());
        n.createObject("1060",con);
    }

    public void creerNotificationMultiple(int[] receiver,String message,String ref,String lien,Connection con) throws Exception{
        boolean check = false;
        try {
            if(con==null) {
                con = (new UtilDB()).GetConn();
                check = true;
                con.setAutoCommit(false);
            }
            for(int r : receiver){
                this.creerNotification(r,message,ref,lien,con);
            }
        } catch (Exception e) {
            if(con != null && check) con.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if(con != null && check) con.close();
        }
    
    }

    public static void notifSys(String message) throws AWTException{
        SystemTray tray = SystemTray.getSystemTray();
        
        Image image = Toolkit.getDefaultToolkit().createImage("icon.png");
        
        TrayIcon trayIcon = new TrayIcon(image, "Tray Demo");
        
        trayIcon.setImageAutoSize(true);
        
        trayIcon.setToolTip("System tray icon demo");
        tray.add(trayIcon);

        trayIcon.displayMessage("Fonds Routier", message, TrayIcon.MessageType.INFO);        
    }

    @Override
    public String toString() {
        return "Notification [ message=" + message + ", ref=" + ref + ", receiver=" + receiver
                + ", lien=" + lien + "]";
    }
}

