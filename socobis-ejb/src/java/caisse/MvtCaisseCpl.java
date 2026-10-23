/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package caisse;

import java.sql.Connection;

import client.Client;
import utilitaire.Utilitaire;
import utilitaire.*;
import vente.Vente;
import vente.VenteLib;
import bean.*;
/**
 *
 * @author nouta
 */
public class MvtCaisseCpl extends MvtCaisse{
    private String idCaisseLib;
    private String idVente;
    String etatLib;
    protected String tiers;
    private String idModePaiementLib;
    private double soldecredit, soldedebit, montantimpute;
    private String idecriture;

    public String getIdecriture() {
        return idecriture;
    }

    public void setIdecriture(String idecriture) {
        this.idecriture = idecriture;
    }

    public String getTiers() {
	 return tiers;
    }

    public void setTiers(String tiers) {
	 this.tiers = tiers;
    }

    public MvtCaisseCpl() {
        super.setNomTable("MOUVEMENTCAISSECPL");
    }

    public String getIdCaisseLib() {
        return idCaisseLib;
    }

    public String getIdVente() {
        return idVente;
    }

    public void setIdVente(String idVente) {
        this.idVente = idVente;
    }

    public String getIdModePaiementLib() {
        return idModePaiementLib;
    }

    public void setIdModePaiementLib(String idModePaiementLib) {
        this.idModePaiementLib = idModePaiementLib;
    }

    public void setIdCaisseLib(String idCaisseLib) {
        this.idCaisseLib = idCaisseLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }
    
    public Client getClientMemeByFacture(String[] ids,Connection c) throws Exception{
        boolean estOuvert=false;
        try
        {
            if (c == null) {
                c=new UtilDB().GetConn();
                estOuvert=true;
            }
            VenteLib[] ventes = (VenteLib[]) CGenUtil.rechercher(new VenteLib(), null, null, c, " and id in ("+Utilitaire.tabToString(ids, "'", ",")+" )");
            if (ventes.length > 0) {
                String clientRef = ventes[0].getIdClient();
                for (Vente v : ventes) {
                    if (!clientRef.equals(v.getIdClient())) {
                        throw new Exception("Toutes les factures doivent appartenir au m\\u00EAme client !");
                    }
                }
                System.out.println("afaka I--------------");
                        MvtCaisseCpl[] mvts = (MvtCaisseCpl[]) CGenUtil.rechercher(
                new MvtCaisseCpl(), null, null, c,
                " and idtiers ='"+clientRef+"'");
                double montantTotalMvtCaisse = AdminGen.calculSommeDouble(mvts, "soldecredit");
                System.out.println("montantTotalMvtCaisse = "+montantTotalMvtCaisse);
                double montantTotalVente = AdminGen.calculSommeDouble(ventes, "montantreste");
                 System.out.println("montantTotalVente = "+montantTotalVente);
                /*if(montantTotalVente>montantTotalMvtCaisse)
                {
                    throw new Exception("Montant insuffisant dans le mouvement de caisse pour ce client");
                }*/
                Client[] clients = (Client[]) CGenUtil.rechercher(new Client(), null, null, c, " and id ='"+clientRef+"'");
                System.out.println("clients = "+clients.length);
                if (clients.length > 0) {
                    return clients[0];
                }
            }
            return null;
        }
        catch(Exception e)
        {
            throw e;
        }
        finally
        {
            if(estOuvert==true) c.close();
        }
    }

    public double getSoldecredit() {
        return soldecredit;
    }

    public void setSoldecredit(double soldecredit) {
        this.soldecredit = soldecredit;
    }

    public double getSoldedebit() {
        return soldedebit;
    }

    public void setSoldedebit(double soldedebit) {
        this.soldedebit = soldedebit;
    }

    public double getMontantimpute() {
        return montantimpute;
    }

    public void setMontantimpute(double montantimpute) {
        this.montantimpute = montantimpute;
    }

    public MvtCaisseCpl getMouvementCaisse (Connection c, MvtCaisseCpl reps) throws Exception{
        MvtCaisseCpl[] mvtCaisseCpls = ( MvtCaisseCpl[])CGenUtil.rechercher(reps, null, null, c, "");
        if(mvtCaisseCpls.length!=0 ) {
            reps = mvtCaisseCpls[0];
            return reps;
        }
        throw new Exception("Pas de mouvement retenue");
    }
}
