package maintenance.travaux;

import bean.ClassFille;

import java.sql.Connection;
import java.sql.Date;

public class OrdreTravauxFille extends ClassFille {
    String id;
    String idMere;
    String idIngredients;
    String remarque,libelle,idunite,libIngredients,idBcFille,operateur,idFab;
    double qte;
    Date datyBesoin;
    double equivalence=1;

    public OrdreTravauxFille() throws Exception {
        super.setNomTable("ORDRETRAVAUXFILLE");
        setLiaisonMere("idMere");
        setNomClasseMere("travaux.OrdreTravaux");
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("OTF", "getseqORDRETRAVAUXFILLE");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
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

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }

    public String getIdIngredients() {
        return idIngredients;
    }

    public void setIdIngredients(String idIngredients) {
        this.idIngredients = idIngredients;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getIdunite() {
        return idunite;
    }

    public void setIdunite(String idunite) {
        this.idunite = idunite;
    }

    public String getLibIngredients() {
        return libIngredients;
    }

    public void setLibIngredients(String libIngredients) {
        this.libIngredients = libIngredients;
    }

    public String getIdBcFille() {
        return idBcFille;
    }

    public void setIdBcFille(String idBcFille) {
        this.idBcFille = idBcFille;
    }

    public String getOperateur() {
        return operateur;
    }

    public void setOperateur(String operateur) {
        this.operateur = operateur;
    }

    public String getIdFab() {
        return idFab;
    }

    public void setIdFab(String idFab) {
        this.idFab = idFab;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }

    public Date getDatyBesoin() {
        return datyBesoin;
    }

    public void setDatyBesoin(Date datyBesoin) {
        this.datyBesoin = datyBesoin;
    }

    public double getEquivalence() {
        return equivalence;
    }

    public void setEquivalence(double equivalence) {
        this.equivalence = equivalence;
    }

//    public Fabrication genererFabrication(Connection c) throws Exception {
//        boolean estOuvert = false;
//        try {
//            if (c == null) {
//                c = new UtilDB().GetConn();
//                estOuvert = true;
//            }
//            OrdreTravauxFille ofFille = (OrdreTravauxFille) this.getById(this.getId(), "ORDRETRAVAUXFILLE", c);
//            this.setQte(ofFille.getQte());
//            OrdreTravaux of = new OrdreTravaux();
//            of = (OrdreTravaux) of.getById(ofFille.getIdMere(), "OrdreTravaux", c);
//            Travaux fab = new Travaux();
//            fab.setIdOffille(this.getId());
//            fab.setCible(of.getCible());
//            fab.setLancePar(of.getLancePar());
//            fab.setDaty(of.getDaty());
//            Recette crt = new Recette();
//            crt.setNomTable("AS_RECOFFVUESTFAB");
//            crt.setIdproduits(this.getId());
//            Recette[] lr = (Recette[]) CGenUtil.rechercher(crt, null, null, c, " and raf>0 and typestock is not null");
//            FabricationFille[] ff = new FabricationFille[lr.length];
//            for (int i = 0; i < lr.length; i++) {
//                ff[i] = lr[i].genererFabricationFille();
//            }
//            fab.setFille(ff);
//            return fab;
//        }
//        catch (Exception e) {
//            e.printStackTrace();
//            throw e;
//        }
//        finally
//        {
//            if(estOuvert==true&&c!=null)c.close();
//        }
//    }

}
