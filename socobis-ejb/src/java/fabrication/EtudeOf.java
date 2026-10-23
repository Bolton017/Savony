package fabrication;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import calculBesoin.ResultatBesoins;
import calculBesoin.ResultatBesoinsParMatiere;
import demande.DemandeTransfert;
import demande.DemandeTransfertFille;
import historique.MapUtilisateur;
import produits.Ingredients;
import produits.Recette;
import stock.EtatStock;
import stock.MvtStockEntreeAvecReste;
import stock.TransfertStock;
import stock.TransfertStockDetails;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utils.ConstanteProcess;
import utils.ConstanteSocobis;

import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Vector;

public class EtudeOf extends ClassMere {
    String id,lancePar,cible,remarque,libelle,idBc;
    Date besoin,daty;
    String etatLib;
    EtudeOfFille[] EtudeOfFilles;
    double nb;

    public EtudeOf() throws Exception
    {
        super.setNomTable("EtudeOF");
        setLiaisonFille("idMere");
        setNomClasseFille("fabrication.EtudeOfFille");
    }

    public boolean getEstIndexable() {
        return true;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("OF", "get_SEQ_EtudeOF");
        this.setId(makePK(c));
    }
    @Override
    public String getTuppleID() {
        return id;
    }

    public  String getNomClasseFille()
    {
        return "fabrication.EtudeOfFille";
    }
    public String getLiaisonFille() {
        return "idMere";
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

    public String getLancePar() {
        return lancePar;
    }

    public void setLancePar(String lancePar) {
        this.lancePar = lancePar;
    }

    public String getCible() {
        return cible;
    }

    public void setCible(String cible) {
        this.cible = cible;
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

    public Date getBesoin() {
        return besoin;
    }

    public void setBesoin(Date besoin) {
        this.besoin = besoin;
    }

    public Date getDaty() {
        return daty;
    }

    public String getIdBc() {
        return idBc;
    }

    public void setIdBc(String idBc) {
        this.idBc = idBc;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Recette[] decomposer(Connection c)throws Exception
    {
        return decomposer("as_recetteOf",c);
    }
    public Recette[] decomposer(String nT,Connection c)throws Exception
    {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Ingredients ing = new Ingredients();
            ing.setId(this.getId());
            return ing.decomposerBase(nT, c);
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }

    public Recette[] decomposerParNiveau(Connection c)throws Exception
    {
        Ingredients ing = new Ingredients();
        ing.setId(this.getId());
        return ing.decomposerParNiveau("AS_RECETTEOFabrication", c," and niveau>1 ");
    }
    public void decomposerParNiveauEtInserer(String u,Connection c) throws Exception
    {
        EtudeOfFille[] lf=(EtudeOfFille[]) this.getFille();
        for(int i=0;i<lf.length;i++)
            lf[i].decomposerParNiveauEtInserer(u,c);
    }
    public void decomposerParNiveauBasEnHautEtInserer(String u,Connection c) throws Exception
    {
        EtudeOfFille[] lf=(EtudeOfFille[]) this.getFille();
        for(int i=0;i<lf.length;i++)
            lf[i].decomposerParNiveaubasEnHautEtInserer(u,c);
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            super.validerObject(u, c);
            this.setFille ((EtudeOfFille[]) this.getFille(null,c,""));
            this.decomposerParNiveauEtInserer(u,c);  //Pour ARTISANAT
            //decomposerParNiveauBasEnHautEtInserer(u, c); // Pour SOCOBIS
            c.commit();
            return this;

        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    @Override
    public Object cloturerObject(String u, Connection c) throws Exception {
        FabricationCpl[] fabrications = (FabricationCpl[]) CGenUtil.rechercher(new FabricationCpl(), null, null, c, " and idOf='"+this.getId()+"' and etat!="+ConstanteProcess.termine);
        if(fabrications.length!=0){
            throw new Exception("Impossible de cloturer cet OF, il existe des fabrications non termines");
        }

        EtudeOf[] ofs = (EtudeOf[])CGenUtil.rechercher(new EtudeOf(), null, null, c, " and id='"+this.getId()+"'");
        if(ofs.length!=0){
            ofs[0].setEtat(ConstanteEtat.getEtatCloture());
            ofs[0].setEtat(ConstanteEtat.getEtatCloture());
            ofs[0].updateToTableWithHisto(u, c);
        }
        return this;
    }

    public Object entamerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            //Mettre controle si besoin
            this.setEtat(ConstanteProcess.entame);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public Object bloquerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            //Mettre controle si besoin
            this.setEtat(ConstanteProcess.bloque);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public Object terminerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            this.setEtat(ConstanteProcess.termine);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    /**
     * Fonction utilisée pour decomposer plusieurs ligne par niveay
     * @param nTRecette
     * @param c
     * @return
     * @throws Exception
     */
    public Recette[] decomposerParNiveau(String nTRecette,Connection c,String apresW) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String req="SELECT\n" +
                    "     ing.pu AS qteAv,\n" +
                    "     CAST(0 AS NUMBER(30,10)) AS qteTotal,\n" +
                    "     ing.unite AS unite,\n" +
                    "     ing.libelle AS libIngredients,ing.id as idIngredients, ing.typestock, ing.IDUNITE,rec.source,ing.COMPOSE,\n" +
                    "     cast((\n" +
                    "         (\n" +
                    "             SELECT\n" +
                    "                 EXP(SUM(LN(ROUND(TO_NUMBER(REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL)),10))))\n" +
                    "             FROM\n" +
                    "                 dual\n" +
                    "             CONNECT BY\n" +
                    "                 REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL) IS NOT NULL\n" +
                    "                 AND PRIOR dbms_random.value IS NOT NULL\n" +
                    "         )\n" +
                    "     ) as number(30,10)) AS quantite, niveau\n" +
                    " FROM (\n" +
                    "     SELECT\n" +
                    "         rec.*,'-' as source,\n" +
                    "         SYS_CONNECT_BY_PATH(quantite, '/') AS path,LEVEL as niveau\n" +
                    "     FROM\n" +
                    "        "+nTRecette +" rec\n" +
                    "     START WITH\n" +
                    "         idproduits = '"+this.getId()+"'\n" +
                    "     CONNECT BY\n" +
                    "         PRIOR idingredients = idproduits\n" +
                    "         AND PRIOR rec.compose = 1\n" +
                    " ) rec\n" +
                    " JOIN AS_INGREDIENTS_LIB ing\n" +
                    "     ON rec.idingredients = ing.id\n" +
                    " where ing.compose>0 "+apresW+ "\n" +
                    " order by niveau asc";
            Recette rec = new Recette();
            rec.setNomTable("recettemontant");
            return (Recette[]) CGenUtil.rechercher(rec, req, c);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (estOuvert == true && c != null)
                c.close();
        }
    }

    public void calculerRevient(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            EtudeOfFille[] liste=(EtudeOfFille[]) this.getFille();
            if(liste==null) liste = (EtudeOfFille[]) this.getFille(null, c, "");
            for (EtudeOfFille f : liste) {
                f.calculerRevient(c);
            }
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }
    public String chaineEtat() {
        if(this.getEtat()==1) return "CREE";
        if(this.getEtat()==11) return "VALIDEE";
        if(this.getEtat()==21) return "ENTAME";
        if(this.getEtat()==31) return "BLOQUE";
        if(this.getEtat()==41) return "TERMINE";
        return "CREE";
    }


    @Override
    public String[] getMotCles() {
        return new String[]{"id","libelle"};
    }

    @Override
    public String[] getValMotCles() {
        return new String[]{"id","libelle"};
    }

    public EtudeOfFille[] getEtudeOfFilles() {
        return EtudeOfFilles;
    }

    public void setEtudeOfFilles(EtudeOfFille[] EtudeOfFilles) {
        this.EtudeOfFilles = EtudeOfFilles;
    }

    public FabricationCpl[] getFabrication(String nomTable, Connection c)throws Exception{
        String table = "fabricationCpl";
        if(nomTable != null){
            table = nomTable;
        }
        FabricationCpl f = new FabricationCpl();
        f.setNomTable(nomTable);
        f.setIdOf(this.getId());
        return (FabricationCpl[]) CGenUtil.rechercher(f, null, null, c, "");
    }

    public TransfertStock genererTransfertStock(Connection c) throws Exception {
        try{
            EtudeOf of  = new EtudeOf();
            of = (EtudeOf) of.getById(this.getId(),"ofab",c);
            TransfertStock ts = new TransfertStock();
            ts.setDesignation("Transfert de stock pour OF "+this.getId());
            ts.setIdMagasinDepart(of.getLancePar());
            ts.setIdMagasinArrive(of.getCible());
            ts.setIdOf(this.getId());
            Recette[] recettes = this.decomposer(c);
            MvtStockEntreeAvecReste depCtr = new MvtStockEntreeAvecReste();
            depCtr.setNomTable("V_ETATSTOCK_ENTREE");
            depCtr.setIdMagasin(of.getLancePar());
            MvtStockEntreeAvecReste[] etatStockDepart = (MvtStockEntreeAvecReste[])CGenUtil.rechercher(depCtr, null, null, c, "order by daty desc");
            Vector<MvtStockEntreeAvecReste> vect = new Vector<MvtStockEntreeAvecReste>(Arrays.asList(etatStockDepart));
            EtatStock arrCtr = new EtatStock();
            arrCtr.setNomTable("V_ETATSTOCK_ING");
            arrCtr.setIdMagasin(of.getCible());
            EtatStock[] etatStockArrive = (EtatStock[])CGenUtil.rechercher(arrCtr, null, null, c, "");
            List<TransfertStockDetails> details = new ArrayList<TransfertStockDetails>();
            for (int i = 0; i < recettes.length; i++) {
                if(recettes[i].getTypeStock()!=null){
                    double reste = 0;
                    EtatStock stockArrive = (EtatStock) AdminGen.findUnique(etatStockArrive,new String[]{"id"},new String[]{recettes[i].getIdingredients()});
                    if(stockArrive != null) {
                        reste = stockArrive.getReste();
                    }
                    double qteATransferer = recettes[i].getQuantite() - reste;

                    while (qteATransferer > 0) {
                        MvtStockEntreeAvecReste stockDepart = (MvtStockEntreeAvecReste) AdminGen.findUnique(vect,new String[]{"idProduit"},new String[]{recettes[i].getIdingredients()});
                        TransfertStockDetails det = new TransfertStockDetails();
                        det.setIdProduit(recettes[i].getIdingredients());
                        det.setRemarque(recettes[i].getLibIngredients()+" - "+recettes[i].getUnite());

                        if(stockDepart != null && stockDepart.getReste() > 0 ){
                            double qteTransferee = qteATransferer;
                            qteTransferee = Math.min(qteATransferer, stockDepart.getReste());
                            stockDepart.setReste(stockDepart.getReste() - qteTransferee);
                            det.setQuantite(qteTransferee);
                            qteATransferer -= qteTransferee;
                            det.setIdSource(stockDepart.getId());
                            det.setPu(stockDepart.getPu());
                            details.add(det);
                            vect.remove(stockDepart);
                        }else {
                            det.setQuantite(recettes[i].getQuantite());
                            det.setPu(recettes[i].getPu());
                            details.add(det);
                            break;
                        }
                    }

                }
            }
            ts.setFille(details.toArray(new TransfertStockDetails[0]));
            return ts;
        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

    }

    public TransfertStock genererTransfertStock(String idMagDepart, String idMagArrive, Connection c) throws Exception {
        try{
            EtudeOf of  = new EtudeOf();
            of = (EtudeOf) of.getById(this.getId(),"ofab",c);
            TransfertStock ts = new TransfertStock();
            ts.setDesignation("Transfert de stock pour OF "+this.getId());
            ts.setIdMagasinDepart(idMagDepart != null ? idMagDepart : of.getLancePar());
            ts.setIdMagasinArrive(idMagArrive != null ? idMagArrive : of.getCible());
            ts.setIdOf(this.getId());
            Recette[] recettes = this.decomposer(c);
            MvtStockEntreeAvecReste depCtr = new MvtStockEntreeAvecReste();
            depCtr.setNomTable("V_ETATSTOCK_ENTREE");
            depCtr.setIdMagasin(idMagDepart != null ? idMagDepart : of.getLancePar());
            MvtStockEntreeAvecReste[] etatStockDepart = (MvtStockEntreeAvecReste[])CGenUtil.rechercher(depCtr, null, null, c, "order by daty desc");
            Vector<MvtStockEntreeAvecReste> vect = new Vector<MvtStockEntreeAvecReste>(Arrays.asList(etatStockDepart));
            EtatStock arrCtr = new EtatStock();
            arrCtr.setNomTable("V_ETATSTOCK_ING");
            arrCtr.setIdMagasin(idMagArrive != null ? idMagArrive : of.getCible());
            EtatStock[] etatStockArrive = (EtatStock[])CGenUtil.rechercher(arrCtr, null, null, c, "");
            List<TransfertStockDetails> details = new ArrayList<TransfertStockDetails>();
            for (int i = 0; i < recettes.length; i++) {
                if(recettes[i].getTypeStock()!=null){
                    double reste = 0;
                    EtatStock stockArrive = (EtatStock) AdminGen.findUnique(etatStockArrive,new String[]{"id"},new String[]{recettes[i].getIdingredients()});
                    if(stockArrive != null) {
                        reste = stockArrive.getReste();
                    }
                    double qteATransferer = recettes[i].getQuantite() - reste;

                    while (qteATransferer > 0) {
                        MvtStockEntreeAvecReste stockDepart = (MvtStockEntreeAvecReste) AdminGen.findUnique(vect,new String[]{"idProduit"},new String[]{recettes[i].getIdingredients()});
                        TransfertStockDetails det = new TransfertStockDetails();
                        det.setIdProduit(recettes[i].getIdingredients());
                        det.setRemarque(recettes[i].getLibIngredients()+" - "+recettes[i].getUnite());

                        if(stockDepart != null && stockDepart.getReste() > 0 ){
                            double qteTransferee = qteATransferer;
                            qteTransferee = Math.min(qteATransferer, stockDepart.getReste());
                            stockDepart.setReste(stockDepart.getReste() - qteTransferee);
                            det.setQuantite(qteTransferee);
                            qteATransferer -= qteTransferee;
                            det.setIdSource(stockDepart.getId());
                            det.setPu(stockDepart.getPu());
                            details.add(det);
                            vect.remove(stockDepart);
                        }else {
                            det.setPu(recettes[i].getPu());
                            det.setQuantite(recettes[i].getQuantite());
                            details.add(det);
                            break;
                        }
                    }

                }
            }
            ts.setFille(details.toArray(new TransfertStockDetails[0]));
            return ts;
        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

    }

    @Override
    public ClassMAPTable createObject(MapUtilisateur u, Connection c)throws Exception{
        if(u.getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG) != 0){
            throw new Exception("Vous n'avez pas le droit de creer un OF!");
        }
        return super.createObject(u,c);
    }

    @Override
    public Object validerObject(MapUtilisateur u, Connection c) throws Exception{
        if(u.getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG) != 0 && (u.getIdrole().compareTo(ConstanteSocobis.CONTREMAITRE_RANG) != 0)){
            throw new Exception("Vous n'avez pas le droit de valider un OF!");
        }
        return super.validerObject(u,c);
    }

    public DemandeTransfert genererDemandeTransfert(String idOf, String idcat, Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            EtudeOf ofdata = new EtudeOf();
            ofdata = (EtudeOf) ofdata.getById(idOf,"ofab",c);
            DemandeTransfert dm = new DemandeTransfert();
            dm.setNomTable("demandetransfert");
            dm.setIdMagasinDepart(ofdata.getLancePar());
            dm.setIdMagasinArrive(ofdata.getCible());
            dm.setIdOf(ofdata.getId());
            dm.setDesignation("Demande de transfert : "+ofdata.getId());
            Vector<DemandeTransfertFille> vect = new Vector<DemandeTransfertFille>();
            Recette[] recettes = ofdata.decomposer(c);
            for(int i=0;i<recettes.length;i++){
                if(idcat!=null && !idcat.equalsIgnoreCase(recettes[i].getCategorieingredient())){
                    continue;
                }
                DemandeTransfertFille data = new DemandeTransfertFille();
                data.setIdProduit(recettes[i].getIdingredients());
                data.setRemarque(recettes[i].getLibIngredients()+" "+recettes[i].getUnite());
                data.setQuantite(recettes[i].getQuantite());
                vect.add(data);
            }
            dm.setFille(vect.toArray(new DemandeTransfertFille[0]));
            return dm;
        } catch (Exception e) {
            throw e;
        } finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }

    public ResultatBesoinsParMatiere[] getBesoinsParMatiere(Connection c) throws Exception {
        boolean localConnection = false;

        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                localConnection = true;
            }

            EtudeOfFille[] filles =
                    (EtudeOfFille[]) getFille(null, c, "");

            List<ResultatBesoinsParMatiere[]> besoinsParFille = new ArrayList<>();

            for (EtudeOfFille fille : filles) {
                ResultatBesoins[] besoins =
                        ResultatBesoins.getResultatBesoin(
                                fille.getIdIngredients(),
                                fille.getQte(),
                                c
                        );
//                Ingredients ing = (Ingredients) new Ingredients().getById(fille.getIdIngredients(),"AS_INGREDIENTS",c);
                besoinsParFille.add(
                        ResultatBesoinsParMatiere.parse(besoins, c,"")
                );
            }

            return ResultatBesoinsParMatiere.merge(besoinsParFille);

        } finally {
            if (localConnection && c != null) {
                try {
                    c.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public double getNb() {
        return nb;
    }

    public void setNb(double nb) {
        this.nb = nb;
    }
}
