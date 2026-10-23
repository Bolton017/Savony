package ristourne;

import avoir.AvoirFC;
import avoir.AvoirFCFille;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import mg.cnaps.compta.ClotureMoisAnnee;
import paiement.LiaisonPaiement;
import utilitaire.Constante;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteSocobis;
import utils.ConstanteVente;
import vente.Vente;
import vente.VenteDetails;
import vente.VenteLib;

import java.sql.Connection;
import java.sql.Date;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Ristourne extends ClassMere {
    String id, designation, idClient, idOrigine;
    Date daty, dateDebutRistourne, dateFinRistourne;
    double taux;
    private String[] ids;
    private int mois, annee;
    private int estLiaisonPaiement;
    private String idVente;

    public Ristourne() throws Exception{
        super.setNomTable("RISTOURNE");
        setLiaisonFille("idRistourne");
        setNomClasseFille("ristourne.RistourneDetails");
    }

    public VenteLib getVente(Connection c) throws Exception{
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                indice = 1;
            }
            Ristourne r = (Ristourne) this.getById(this.getId(), "RISTOURNE", null);
            String[] origines = utilitaire.Utilitaire.split(r.getIdOrigine(), ",");
            VenteLib vente = new VenteLib();
            VenteLib[] ventes = (VenteLib[]) CGenUtil.rechercher(vente, null, null, c, " AND ID IN (" + Utilitaire.tabToString(origines, "'", ",") + ")");
            VenteLib res = null;
            if(ventes.length>0){
                res = ventes[0];
                System.err.println(ventes.length+"TAILLL");
                for(int i=1;i<ventes.length;i++){
                    System.err.println(res.getMontantreste()+ventes[i].getMontantreste()+"PRIXXX");
                    res.setMontantttc(res.getMontantreste()+ventes[i].getMontantreste());
                    res.setId(res.getId()+";;"+ventes[i].getId());
                }
            }
            return res;
        }catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        }finally{
            if(indice == 1 && c!=null)c.close();
        }
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RIS", "getseqristourne");
        this.setId(makePK(c));
    }

    public int getEstLiaisonPaiement() {
        return estLiaisonPaiement;
    }

    public void setEstLiaisonPaiement(int estLiaisonPaiement) {
        this.estLiaisonPaiement = estLiaisonPaiement;
    }

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public  String getNomClasseFille()
    {
        return "ristourne.RistourneDetails";
    }

    public String getLiaisonFille() {
        return "idRistourne";
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdClient() {
        return idClient;
    }

    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDateDebutRistourne() {
        return dateDebutRistourne;
    }

    public void setDateDebutRistourne(Date dateDebutRistourne) {
        this.dateDebutRistourne = dateDebutRistourne;
    }

    public Date getDateFinRistourne() {
        return dateFinRistourne;
    }

    public void setDateFinRistourne(Date dateFinRestourne) {
        this.dateFinRistourne = dateFinRestourne;
    }

    public String getIdVente() {
        return idVente;
    }

    public void setIdVente(String idVente) {
        this.idVente = idVente;
    }

    /*@Override
    public Object validerObject(String u, Connection c) throws Exception {
        this.ids = utilitaire.Utilitaire.split(this.getIdOrigine(), ",");
        RistourneDetails[] filles = (RistourneDetails[])this.getFille(null, c, "");
        Vente vente =  new Vente();
        Vente[]ventes = (Vente[]) CGenUtil.rechercher(vente, null, null, c, " AND ID IN ("+ Utilitaire.tabToString(this.ids, "'", ",")+")");

        for (Vente value : ventes) {
            AvoirFC avoir = Vente.transformerFactureToAvoir(value);
            avoir.setEtat(11);
            VenteDetails[] ventedetails = value.getDetailsLib(c);
            ArrayList<AvoirFCFille> avoirsFilles = new ArrayList<>();
            for (VenteDetails vds : ventedetails) {
                for(int j=0;j<filles.length;j++){
                    if(filles[j].getIdProduit().compareToIgnoreCase(vds.getIdProduit())==0) {
                        AvoirFCFille fille = Vente.transformerFactureToAvoirFille(vds);
                        fille.setIdProduit(vds.getIdProduit());
                        fille.setQte(1);
                        fille.setEtat(11);
                        double prix = vds.getPu()*vds.getQte();
                        double prixsansremise = (prix)-((prix)*vds.getRemise())/100;
                        fille.setPu((prixsansremise*filles[j].getTaux1())/100);
                        avoirsFilles.add(fille);
                    }
                }
            }
            if(avoirsFilles.size()>0){
                avoir.setFille(avoirsFilles.toArray(new AvoirFCFille[0]));
                avoir.createObject(u,c);
            }
        }

        return super.validerObject(u, c);
    }
     */

    @Override
    public ClassMAPTable createObjectBatch(String u, Statement st) throws Exception {
        Ristourne r = new Ristourne();
        Ristourne[] existing = (Ristourne[]) CGenUtil.rechercher(r, null, null, st.getConnection(),
                " AND IDCLIENT='" + this.getIdClient() + "' AND MOIS=" + this.getMois() + " AND ANNEE=" + this.getAnnee()
        );
        if (existing.length > 0) {
//            throw new Exception("Une ristourne pour ce client et cette période existe déjà (id=" + existing[0].getId() + ")");
        }
        return super.createObjectBatch(u, st);
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        Ristourne r = new Ristourne();
        Ristourne[] existing = (Ristourne[]) CGenUtil.rechercher(r, null, null, c,
                " AND IDCLIENT='" + this.getIdClient() + "' AND MOIS=" + this.getMois() + " AND ANNEE=" + this.getAnnee()
        );
        if (existing.length > 0) {
//            throw new Exception("Une ristourne pour ce client et cette période existe déjà (id=" + existing[0].getId() + ")");
        }
        return super.createObject(u, c);
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        this.ids = utilitaire.Utilitaire.split(this.getIdOrigine(), ",");

        if (getEstLiaisonPaiement() == 1) {
            this.ids = new String[]{getIdVente()};
        }

        RistourneDetails[] filles = (RistourneDetails[]) this.getFille(null, c, "");
        Vente vente = new Vente();
        Vente[] ventes = (Vente[]) CGenUtil.rechercher(
                vente, null, null, c,
                " AND ID IN (" + Utilitaire.tabToString(this.ids, "'", ",") + ")"
        );

        // ------------------------------
        // UN SEUL AVOIR GLOBAL
        // ------------------------------
        AvoirFC avoir = new AvoirFC();
        if (ventes.length > 0) {
            Vente first = ventes[0]; // prendre infos générales sur la première vente
            avoir.setDesignation(first.getDesignation());
            avoir.setIdMagasin(first.getIdMagasin());
            avoir.setRemarque(first.getRemarque());
            avoir.setIdOrigine(Utilitaire.tabToString(this.ids, "", ";;"));
            if(this.ids.length==1){
                avoir.setIdVente(this.ids[0]);
            }
            //avoir.setIdVente(Utilitaire.tabToString(this.ids, "", ";;"));
            avoir.setIdClient(first.getIdClient());
            avoir.setIdMotif(ConstanteSocobis.ID_MOTIF_RISTOURNE);
            avoir.setCompte(first.getCompte());
            avoir.setDaty(Utilitaire.dateDuJourSql());
            avoir.setEtat(1);
            avoir.setIdtypeavoir(ConstanteVente.idtyperistourne);
            avoir.setIdristourne(this.getId());
        }

        // Regrouper par idProduit
        Map<String, AvoirFCFille> mapFilles = new HashMap<>();

        double sommeMontantAvoir = 0;
        for (Vente value : ventes) {
            VenteDetails[] ventedetails = value.getDetailsLib(c);

            for (VenteDetails vds : ventedetails) {
                for (RistourneDetails filleR : filles) {
                    if (filleR.getIdProduit().equalsIgnoreCase(vds.getIdProduit())) {

                        // calcul prix net (avec remise)
                        //double prix = vds.getPu() * vds.getQte();
                        double prix = vds.getPu() * vds.getQte();

                        double htApresRemise = prix - ((prix * vds.getRemise()) / 100);

                        double montantFinal = htApresRemise * filleR.getTaux1() / 100;

                        //double montantFinal = (prix * filleR.getTaux1()) / 100;

                        // si déjà existant → on cumule
                        if (mapFilles.containsKey(vds.getIdProduit())) {
                            AvoirFCFille existing = mapFilles.get(vds.getIdProduit());
                            existing.setPu(existing.getPu() + montantFinal);
                            //existing.setQte(vds.getQte());
                            existing.setQte(1);
                            existing.setTaux(vds.getQte());
                        } else {
                            AvoirFCFille newFille = Vente.transformerFactureToAvoirFille(vds);
                            newFille.setIdProduit(vds.getIdProduit());
                            newFille.setEtat(11);
                            newFille.setQte(1);
                            //newFille.setQte(vds.getQte());
                            newFille.setTva(vds.getTva());
                            newFille.setPu(montantFinal);
                            newFille.setTaux(vds.getQte());
                            mapFilles.put(vds.getIdProduit(), newFille);
                        }

                        double tva = vds.getTva(); // en %
                        double montantTva = (montantFinal * tva) / 100;
                        double montantTtc = montantFinal + montantTva;

                        sommeMontantAvoir += montantTtc;

                        //sommeMontantAvoir += montantFinal;
                    }
                }
            }
        }

        if (!mapFilles.isEmpty()) {
            avoir.setFille(mapFilles.values().toArray(new AvoirFCFille[0]));
            avoir.createObject(u, c); // Un seul enregistrement
            avoir.validerObject(u,c);
        }

        if (getEstLiaisonPaiement() == 1) { // ristourne generer et valider en metier
            LiaisonPaiement liaisonPaiement = new LiaisonPaiement();
            liaisonPaiement.setId1(avoir.getId());
            liaisonPaiement.setId2(getIdVente());
            liaisonPaiement.setMontant(sommeMontantAvoir);
            liaisonPaiement.setEtat(ConstanteEtat.getEtatValider());
            liaisonPaiement.createObject(u, c);
        }
        return super.validerObject(u, c);
    }

    @Override
    public Object validerObjectBatch(String u, Statement st) throws Exception {
        Connection c = st.getConnection();
        this.ids = utilitaire.Utilitaire.split(this.getIdOrigine(), ",");

        if (getEstLiaisonPaiement() == 1) {
            this.ids = new String[]{getIdVente()};
        }

        RistourneDetails[] filles = (RistourneDetails[]) this.getFille(null, c, "");
        Vente vente = new Vente();
        Vente[] ventes = (Vente[]) CGenUtil.rechercher(
                vente, null, null, c,
                " AND ID IN (" + Utilitaire.tabToString(this.ids, "'", ",") + ")"
        );

        // ------------------------------
        // UN SEUL AVOIR GLOBAL
        // ------------------------------
        AvoirFC avoir = new AvoirFC();
        if (ventes.length > 0) {
            Vente first = ventes[0]; // prendre infos générales sur la première vente
            avoir.setDesignation(first.getDesignation());
            avoir.setIdMagasin(first.getIdMagasin());
            avoir.setRemarque(first.getRemarque());
            avoir.setIdOrigine(Utilitaire.tabToString(this.ids, "", ";;"));
            if(this.ids.length==1){
                avoir.setIdVente(this.ids[0]);
            }
            //avoir.setIdVente(Utilitaire.tabToString(this.ids, "", ";;"));
            avoir.setIdClient(first.getIdClient());
            avoir.setIdMotif(ConstanteSocobis.ID_MOTIF_RISTOURNE);
            avoir.setCompte(first.getCompte());
            avoir.setDaty(Utilitaire.dateDuJourSql());
            avoir.setEtat(1);
            avoir.setIdtypeavoir(ConstanteVente.idtyperistourne);
            avoir.setIdristourne(this.getId());
        }

        // Regrouper par idProduit
        Map<String, AvoirFCFille> mapFilles = new HashMap<>();

        double sommeMontantAvoir = 0;
        for (Vente value : ventes) {
            VenteDetails[] ventedetails = value.getDetailsLib(c);

            for (VenteDetails vds : ventedetails) {
                for (RistourneDetails filleR : filles) {
                    if (filleR.getIdProduit().equalsIgnoreCase(vds.getIdProduit())) {

                        // calcul prix net (avec remise)
                        //double prix = vds.getPu() * vds.getQte();
                        double prix = vds.getPu() * vds.getQte();

                        double htApresRemise = prix - ((prix * vds.getRemise()) / 100);

                        double montantFinal = htApresRemise * filleR.getTaux1() / 100;

                        //double montantFinal = (prix * filleR.getTaux1()) / 100;

                        // si déjà existant → on cumule
                        if (mapFilles.containsKey(vds.getIdProduit())) {
                            AvoirFCFille existing = mapFilles.get(vds.getIdProduit());
                            existing.setPu(existing.getPu() + montantFinal);
                            //existing.setQte(vds.getQte());
                            existing.setQte(1);
                            existing.setTaux(vds.getQte());
                        } else {
                            AvoirFCFille newFille = Vente.transformerFactureToAvoirFille(vds);
                            newFille.setIdProduit(vds.getIdProduit());
                            newFille.setEtat(11);
                            newFille.setQte(1);
                            //newFille.setQte(vds.getQte());
                            newFille.setTva(vds.getTva());
                            newFille.setPu(montantFinal);
                            newFille.setTaux(vds.getQte());
                            mapFilles.put(vds.getIdProduit(), newFille);
                        }

                        double tva = vds.getTva(); // en %
                        double montantTva = (montantFinal * tva) / 100;
                        double montantTtc = montantFinal + montantTva;

                        sommeMontantAvoir += montantTtc;

                        //sommeMontantAvoir += montantFinal;
                    }
                }
            }
        }

        if (!mapFilles.isEmpty()) {
            avoir.setFille(mapFilles.values().toArray(new AvoirFCFille[0]));
            avoir.createObjectBatch(u, st); // Un seul enregistrement
            avoir.validerObjectBatch(u,st);
        }

        if (getEstLiaisonPaiement() == 1) { // ristourne generer et valider en metier
            LiaisonPaiement liaisonPaiement = new LiaisonPaiement();
            liaisonPaiement.setId1(avoir.getId());
            liaisonPaiement.setId2(getIdVente());
            liaisonPaiement.setMontant(sommeMontantAvoir);
            liaisonPaiement.setEtat(ConstanteEtat.getEtatValider());
            liaisonPaiement.createObjectBatch(u, st);
        }
        return super.validerObjectBatch(u, st);
    }
}
