package vente;

import bean.AdminGen;
import bean.ClassMAPTable;
import caisse.Caisse;
import caisse.MouvementCaisseFille;
import caisse.MouvementCaisseMere;
import mg.cnaps.compta.ConstanteCompta;
import stock.MvtStock;
import utilitaire.Utilitaire;
import utils.ConstanteAsync;

import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VentePaiement extends Vente{
    PaiementInfo[] paiementInfos;
    Caisse[] listeCaissePoint;
    Caisse caisseEspeceDefaut;

    public VentePaiement() throws Exception
    {
        this.setNomTable("VENTE");
    }
    public double getMontantPayementRecu() throws  Exception
    {
        return AdminGen.calculSommeDouble(paiementInfos,"montant");
    }
    public PaiementInfo getPaiementEspece() throws Exception
    {
        PaiementInfo paiementEspece[]=(PaiementInfo[]) AdminGen.find(getPaiementInfos(),new String[]{"modePaiement"},new String[]{ConstanteAsync.PAIEMENT_ESPECE});
        if(paiementEspece==null||paiementEspece.length==0) return null;
        return  paiementEspece[0];
    }
    public PaiementInfo getPaiementMobile() throws Exception
    {
        PaiementInfo paiementEspece[]=(PaiementInfo[]) AdminGen.find(getPaiementInfos(),new String[]{"modePaiement"},new String[]{ConstanteAsync.PAIEMENT_MOBILEMONEY});
        if(paiementEspece==null||paiementEspece.length==0) return null;
        return  paiementEspece[0];
    }



    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        Statement st = null;
        try {
            c.setAutoCommit(false);
            st = c.createStatement();
            
            this.setUserFacture(u);
            this.setModepaiement(paiementInfos[0].getModePaiement());
            this.setIdResponsable(u);
            if(paiementInfos.length>1) {
                this.setModepaiement(ConstanteAsync.PAIEMENT_MULTIPLE);
            } else {
                this.setModepaiement(paiementInfos[0].getModePaiement());
            }
            this.setDatyPrevu(Utilitaire.dateDuJourSql());
            super.setIsAppoint(true);
            super.createObjectBatch(u, st);

            MouvementCaisseMere mvtCaisseMere = this.genererEncaissementBatch(u, st);
            mvtCaisseMere.setVente(this);
            mvtCaisseMere.createObjectBatch(u, st);
            MvtStock mvt=super.genererMvtStock(c);
            mvt.createObjectBatch(u, st);
            ClassMAPTable retour= (ClassMAPTable) super.validerObjectBatch(u, st);
            mvtCaisseMere.validerObjectBatch(u, st);
            mvt.validerObjectBatch(u,st);
            st.executeBatch();
//            mvt.validerObjectBatch(u,st);
//            st.executeBatch();
            c.commit();
            return retour;
        }
        catch(Exception e) {
            c.rollback();
            throw e;
        }
        finally {
            if(st!=null) {st.close();}
        }
    }

    public MouvementCaisseMere genererEncaissementBatch(String u, Statement st) throws Exception
    {
        try{
            double montantPaye=this.getMontantPayementRecu()-this.getMontantRetourner();
            System.out.println("MONTANT RETORUNER ===> " + this.getMontantRetourner());
            System.out.println("NEW MONTANT PAYE =====>  " + montantPaye);


            MouvementCaisseMere mvtCaisseMere = new MouvementCaisseMere();
            mvtCaisseMere.setCredit(this.getMontantTTCCalcul());
            mvtCaisseMere.setDaty(this.getDaty());
            mvtCaisseMere.setIdtiers(this.getIdClient());
            mvtCaisseMere.setIdorigine(this.getId());
            mvtCaisseMere.setVenteDirecte(true);


            List<MouvementCaisseFille> mvtCaisseFilleListe = new ArrayList<>();
            Map<PaiementInfo, MouvementCaisseFille> filleParPaiement = new HashMap<>();

            double app=this.getAppoint(montantPaye);

            for (PaiementInfo pi : this.getPaiementInfos())
            {
                if(pi.getModePaiement()==null||pi.getModePaiement().equals(""))continue;
                String idCaisse = "";
                MouvementCaisseFille mvtCaisseFille = new MouvementCaisseFille();
                mvtCaisseFille.setCredit(pi.getMontant());
                mvtCaisseFille.setReference(this.getId());
                mvtCaisseFille.setIdModePaiement(pi.getModePaiement());
                mvtCaisseFille.setDesignation("POS Encaissement de la facture Num :" + this.getId() + " " + this.getDaty());
                mvtCaisseFille.setIdDevise("AR");
                mvtCaisseFille.setTaux(1);
                mvtCaisseFille.setHeure(Utilitaire.getCurrentHeure());
                mvtCaisseFille.setIdCassier(u);
                mvtCaisseFille.setIdOrigine(this.getId());
//                mvtCaisseFille.setCredit(pi.getMontant());
                mvtCaisseFille.construirePK(st.getConnection());


//                String modePaiement = this.getIdModePaiement(pi.getModePaiement());

                if (pi.getIdCaisse()==null || pi.getIdCaisse().compareToIgnoreCase("")==0 || pi.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategEspeece) == 0) {
                    idCaisse = this.getCaisseEspeceDefaut().getId();
                    if(montantPaye>this.getMontantTTCCalc()+ConstanteCompta.montantMinimumAppoint)throw new Exception("Le montant est sup\u00E9rieur");
                    //app = this.getAppoint(pi.getMontant());
                    mvtCaisseFille.setCredit(pi.getMontant()-this.getMontantRetourner()-app);
                } else if(pi.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategTpe)==0 || pi.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategTpe)==0) {
                    idCaisse = this.getCaisseId(ConstanteAsync.caisseCategTpe);
                } else if(pi.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategMvola)==0) {
                    if(montantPaye>this.getMontantTTCCalc()+ConstanteCompta.montantMinimumAppoint)throw new Exception("Le montant est sup\u00E9rieur");
                    idCaisse = this.getCaisseId(ConstanteAsync.caisseCategMvola);
                    mvtCaisseFille.setCredit(pi.getMontant()-app);
                } else if(pi.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategOrange)==0) {
                    if(montantPaye>this.getMontantTTCCalc()+ConstanteCompta.montantMinimumAppoint)throw new Exception("Le montant est sup\u00E9rieur");
                    idCaisse = this.getCaisseId(ConstanteAsync.caisseCategOrange);
                    mvtCaisseFille.setCredit(pi.getMontant()-app);
                } else if(pi.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategAirtel)==0) {
                    if(montantPaye>this.getMontantTTCCalc()+ConstanteCompta.montantMinimumAppoint)throw new Exception("Le montant est sup\u00E9rieur");
                    idCaisse = this.getCaisseId(ConstanteAsync.caisseCategAirtel);
                    mvtCaisseFille.setCredit(pi.getMontant()-app);
                } else if(pi.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategCheque)==0) {
                    if(montantPaye>this.getMontantTTCCalc()+ConstanteCompta.montantMinimumAppoint)throw new Exception("Le montant est sup\u00E9rieur");
                    idCaisse = this.getCaisseId(ConstanteAsync.caisseCategCheque);
                    mvtCaisseFille.setCredit(pi.getMontant()-app);
                } else if(pi.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseBonAchat)==0) {
                    idCaisse = this.getCaisseId(ConstanteAsync.caisseBonAchat);
                    mvtCaisseFille.setCredit(pi.getMontant());
                } else if(pi.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCadeaux)==0) {
                    idCaisse = this.getCaisseId(ConstanteAsync.caisseCadeaux);
                    mvtCaisseFille.setCredit(pi.getMontant()-app);
                }

                mvtCaisseFille.setIdCaisse(idCaisse);
                mvtCaisseFilleListe.add(mvtCaisseFille);
                filleParPaiement.put(pi, mvtCaisseFille);

            }
            MouvementCaisseFille mvtApp=null;
            if(this.getIsAppoint()==true)
            {

                if(app!=0&&Math.abs(app)<=ConstanteCompta.montantMinimumAppoint)
                {
                    PaiementInfo payementMobile=this.getPaiementMobile();
                    PaiementInfo paiementEspece = this.getPaiementEspece();
                    String idOrigineAppoint = this.getId();

                    String idCaisse=null;
                    if(this.getPaiementEspece()!=null)
                    {
                        idCaisse=this.getCaisseEspeceDefaut().getId();
                        MouvementCaisseFille filleEspece = filleParPaiement.get(paiementEspece);
                        if (filleEspece != null) idOrigineAppoint = filleEspece.getId();
                    }
                    else if(payementMobile!=null)
                    {
                        if(payementMobile.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategMvola)==0) {
                            idCaisse = this.getCaisseId(ConstanteAsync.caisseCategMvola);
                        } else if(payementMobile.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategOrange)==0) {
                            idCaisse = this.getCaisseId(ConstanteAsync.caisseCategOrange);
                        } else if(payementMobile.getIdCaisse().compareToIgnoreCase(ConstanteAsync.caisseCategAirtel)==0) {
                            idCaisse = this.getCaisseId(ConstanteAsync.caisseCategAirtel);
                        }

                        MouvementCaisseFille filleMobile = filleParPaiement.get(payementMobile);
                        if (filleMobile != null) idOrigineAppoint = filleMobile.getId();

                    }
                    if(idCaisse != null && !idCaisse.isEmpty()) {
                        System.out.println(" id origine appoint ++++++ " + idOrigineAppoint);
                        mvtApp = this.creerAPpoint(app, idCaisse, idOrigineAppoint);
                    }
                    //this.ajouterFille(vdAP);
                }
            }
            if(mvtApp!=null)mvtCaisseFilleListe.add(mvtApp);
            mvtCaisseMere.setFille(mvtCaisseFilleListe.toArray(new MouvementCaisseFille[0]));

            return mvtCaisseMere;

        } catch (Exception e) {
            throw e;
        }
    }


    private String getCaisseId(String categorie) throws Exception {
        Caisse caisse = Caisse.getCaisseParCat(
                this.getListeCaissePoint(),
                categorie
        );

        if (caisse == null) {
            throw new Exception(
                    "Caisse introuvable pour le mode de paiement s\u00E9lectionn\u00E9"
            );
        }

        if (caisse.getId() == null || caisse.getId().trim().isEmpty()) {
            throw new Exception(
                    "Caisse introuvable pour le mode de paiement s\u00E9lectionn\u00E9"
            );
        }

        return caisse.getId();
    }


    public PaiementInfo[] getPaiementInfos() {
        return paiementInfos;
    }

    public void setPaiementInfos(PaiementInfo[] paiementInfos) {
        this.paiementInfos = paiementInfos;
    }


    public Caisse[] getListeCaissePoint() {
        return listeCaissePoint;
    }

    public void setListeCaissePoint(Caisse[] listeCaissePoint) {
        this.listeCaissePoint = listeCaissePoint;
    }

    public Caisse getCaisseEspeceDefaut() {
        return caisseEspeceDefaut;
    }

    public void setCaisseEspeceDefaut(Caisse caisseEspeceDefaut) {
        this.caisseEspeceDefaut = caisseEspeceDefaut;
    }
}
