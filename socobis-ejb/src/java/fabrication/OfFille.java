package fabrication;

import annexe.EquivalenceCarton;
import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMere;
import chatbot.AiColDesc;
import produits.Ingredients;
import produits.Recette;
import produits.RecetteAtelier;
import utilitaire.UtilDB;
import utils.ConstanteSocobis;

import java.sql.Connection;
import java.sql.Date;
import java.util.Vector;

public class OfFille extends ClassFille
{
    @AiColDesc("l'id d'un OF fille, commence par OFF, l'utilisateur va toujours recherche un id mere du coup idMere mais pas id")
    String id;
    @AiColDesc("l'id d'un OF mere, commence par OF")
    String idMere;
    @AiColDesc("Ne jamais remplir si de type saisie")
    String idIngredients;
    String remarque,libelle, idunite,libIngredients,idBcFille,operateur,idFab;
    @AiColDesc("Qte qui a ete commande")
    double qte;
    Date datyBesoin;
    double equivalence=1;
    public Recette[] decomposerParNiveau(Connection c) throws Exception {
        Ingredients p = new Ingredients();
        p.setId(this.getId());
        return p.decomposerParNiveau("AS_RECETTEOFF",c," and niveau>=1");
    }
    public Recette[] decomposerParNiveauBasEnHaut(Connection c) throws Exception {
        Recette[] liste= this.decomposerParNiveau(c);
        String[] atrEt={"niveau"};
        String[] valEt={String.valueOf(liste[liste.length-1].getNiveau())};
        return (Recette[]) AdminGen.findCast(liste,atrEt,valEt);
    }

    public void decomposerParNiveauEtInserer(String u,Connection c) throws Exception
    {
        Recette[] lr=this.decomposerParNiveau(c);
        for(Recette r:lr)
        {
            r.setIdproduits(this.getId());
            r.setNomTable("AS_RECETTEOFFFABTABLE");
            r.createObject(u,c);
        }
    }
    public void decomposerParNiveaubasEnHautEtInserer(String u,Connection c) throws Exception
    {
        Recette[] lr=this.decomposerParNiveauBasEnHaut(c);
        for(Recette r:lr)
        {
            r.setIdproduits(this.getId());
            r.setNomTable("AS_RECETTEOFFFABTABLE");
            r.createObject(u,c);
        }
    }
    public FabricationFille[] genererFabricationFilleBasEnHaut(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Recette crt = new Recette();
            crt.setNomTable("AS_RECOFFVUESTFAB");
            crt.setIdproduits(this.getId());
            Recette[] lr = (Recette[]) CGenUtil.rechercher(crt, null, null, c, " and raf>0");
            FabricationFille[] ff = new FabricationFille[lr.length];
            for (int i = 0; i < lr.length; i++) {
                ff[i] = lr[i].genererFabricationFille();
            }
            return ff;
        }
        catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        finally
        {
            if(estOuvert==true&&c!=null)c.close();
        }
    }

    public Fabrication genererFabrication(Connection c) throws Exception {
        return genererFabrication(null, false, c);
    }
    public Fabrication genererFabrication(String typeAtelier, boolean proposerRaf, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            OfFille ofFille = (OfFille) this.getById(this.getId(), "OfFille", c);
            this.setQte(ofFille.getQte());
            Of of = new Of();
            of = (Of) of.getById(ofFille.getIdMere(), "Ofab", c);
            Fabrication fab = new Fabrication();
            fab.setIdOffille(this.getId());
            fab.setCible(of.getCible());
            fab.setLancePar(of.getLancePar());
            fab.setDaty(of.getDaty());
            RecetteAtelier crt = new RecetteAtelier();
            crt.setIdproduits(this.getId());
            String awhere = " and raf>0 and typestock is not null";
            if (typeAtelier != null && !typeAtelier.trim().isEmpty()) {
                awhere += " and atelier='" + typeAtelier + "'";
            }
//            RecetteAtelier[] lr = (RecetteAtelier[]) CGenUtil.rechercher(crt, null, null, c, " and raf>0 and typestock is not null and atelier is not null");
            RecetteAtelier[] lr = (RecetteAtelier[]) CGenUtil.rechercher(crt, null, null, c, awhere);
            FabricationFille[] ff = new FabricationFille[lr.length];
            for (int i = 0; i < lr.length; i++) {
                ff[i] = lr[i].genererFabricationFille();
                if (proposerRaf){
                    SituationOfFille situationOfFille = new SituationOfFille();
                    situationOfFille.setIdingredients(ff[i].getIdIngredients());
                    situationOfFille.setIdproduits(this.getId());
                    SituationOfFille[] situationOfFilles = (SituationOfFille[]) CGenUtil.rechercher(situationOfFille,null,null, c, "");
                    if (situationOfFilles.length > 0) {
                        ff[i].setQte(situationOfFilles[0].getRaf());
                    }
                }
            }
            fab.setFille(ff);
            return fab;
        }
        catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        finally
        {
            if(estOuvert==true&&c!=null)c.close();
        }
    }

    public Fabrication genererFabricationUnParUn(Connection c) throws Exception {
        return genererFabricationUnParUn(null, false, c);
    }
    public Fabrication genererFabricationUnParUn(String typeAtelier, boolean proposerRaf, Connection c) throws Exception {
        Fabrication ret = genererFabrication(typeAtelier, proposerRaf, c);
        FabricationFille[] lfille = (FabricationFille[]) (ret.getFille());
        double nbCartonPetrin = 0;
        EquivalenceCarton crt = new EquivalenceCarton();
        crt.setNomTable("equivalencecarton");
        crt.setIdCarton(this.getIdIngredients());
        EquivalenceCarton[] listeCarton = (EquivalenceCarton[]) CGenUtil.rechercher(crt, null, null, c, "");
        EquivalenceCarton carton = null;
        if (listeCarton.length > 0) carton = listeCarton[0];
        if(carton != null){
            nbCartonPetrin += carton.getNbcarton();
        }
        for (int i = 0; i < lfille.length; i++) {
            double qtePetrin = lfille[i].getQte() * nbCartonPetrin / this.getQte();
            lfille[i].setRemarque("fabrication de "+ qtePetrin +" "+lfille[i].getLibIngredients());
            lfille[i].setQte(qtePetrin);
        }
        return ret;
    }

    public FabricationFille[] genererFabricationFille(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Recette crt = new Recette();
            crt.setNomTable("AS_RECOFFVUESTFAB");
            crt.setIdproduits(this.getId());
            Recette[] lr = (Recette[]) CGenUtil.rechercher(crt, null, null, c, " and raf>0 and typestock is not null");
            FabricationFille[] ff = new FabricationFille[lr.length];
            for (int i = 0; i < lr.length; i++) {
                ff[i] = lr[i].genererFabricationFille();
            }
            return ff;
        }
        catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        finally
        {
            if(estOuvert==true&&c!=null)c.close();
        }
    }
    public double getEquivalence() {
        return equivalence;
    }
    public void setEquivalence(double equivalence) {
        this.equivalence = equivalence;
    }
    public double getQteAvecEquivalence() {
        return this.getQte()*this.getEquivalence();
    }

    public String getIdFab() {
        return idFab;
    }

    public void setIdFab(String idFab) {
        this.idFab = idFab;
    }

    /*Reto manaraka reto tsy atao anaty table*/
    double dureeHeure,qteFabriques,puRevient;

    public double getPuRevient() {
        return puRevient;
    }

    public String getLibIngredients() {
        return libIngredients;
    }

    public void setLibIngredients(String libIngredients) {
        this.libIngredients = libIngredients;
    }

    public void setPuRevient(double puRevient) {
        this.puRevient = puRevient;
    }
    public double getMontantRevient() {
        return getPuRevient()*getQte();
    }
    public void calculerRevient(Connection c) throws Exception {
        if(this.getIdIngredients()==null)setPuRevient(0);
        Ingredients i=(Ingredients)new Ingredients().getById(this.getIdIngredients(),null,c);
        if(i.getCompose()==0)
        {
            this.setPuRevient(i.getPu());
            return;
        }
        double revient=i.calculerRevient(c);
        this.setPuRevient(revient);
    }

    public String getIdMere() {
        return idMere;
    }
    public OfFille() throws Exception {
        super.setNomTable("OfFille");
        setLiaisonMere("idMere");
        setNomClasseMere("fabrication.Of");
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("OFF", "getseqoffille");
        this.setId(makePK(c));
    }

    public double getDureeHeure() {
        return dureeHeure;
    }

    public void setDureeHeure(double dureeHeure) {
        this.dureeHeure = dureeHeure;
    }

    public double getQteFabriques() {
        return qteFabriques;
    }

    public String getOperateur() {
        return operateur;
    }

    public void setOperateur(String operateur) {
        this.operateur = operateur;
    }
    
    public void setQteFabriques(double qteFabriques) {
        this.qteFabriques = qteFabriques;
    }

    public String getIdunite() {
        return idunite;
    }

    public void setIdunite(String idunite) {
        this.idunite = idunite;
    }

    public void setIdMere(String mere) {
        this.idMere = mere;
    }
    @Override
    public String getNomClasseMere()
    {
        return "fabrication.Of";
    }
    @Override
    public String getLiaisonMere()
    {
        return "idMere";
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

    public String getIdIngredients() {
        return idIngredients;
    }

    public void setIdIngredients(String idIngredients)throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0&&(idIngredients==null||idIngredients.compareToIgnoreCase("")==0)) throw new Exception("Composant obligatoire");
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

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif") == 0 && qte <= 0) throw new Exception("quantite non valide");
        this.qte = qte;
    }

    public Date getDatyBesoin() {
        return datyBesoin;
    }

    public void setDatyBesoin(Date datyBesoin) {
        this.datyBesoin = datyBesoin;
    }

    public String getIdBcFille() {
        return idBcFille;
    }

    public void setIdBcFille(String idBcFille) {
        this.idBcFille = idBcFille;
    }
    
    
}
