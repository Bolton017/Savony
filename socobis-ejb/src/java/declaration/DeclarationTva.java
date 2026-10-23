package declaration;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import faturefournisseur.FactureDeclaration;
import faturefournisseur.FactureDeclarationCpl;
import faturefournisseur.FactureDeclarationDetails;
import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaSousEcriture;
import mg.cnaps.compta.ComptaSousEcritureLib;
import mg.cnaps.compta.ConstanteCompta;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteStation;

import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class DeclarationTva extends ClassEtat {

    public String id;
    public String designation;
    public Date datydebut;
    public  Date datyfin;
    public int mois;
    public int annee;
    HashMap<String,ImprimerDeclaration> donnees;

    
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

    public HashMap<String, ImprimerDeclaration> getDonnees() {
        return donnees;
    }

    public void setDonnees(HashMap<String, ImprimerDeclaration> donnees) {
        this.donnees = donnees;
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

    public Date getDatydebut() {
        return datydebut;
    }

    public void setDatydebut(Date datydebut) {
        this.datydebut = datydebut;
    }

    public Date getDatyfin() {
        return datyfin;
    }

    public void setDatyfin(Date datyfin) {
        this.datyfin = datyfin;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DTVA", "getSeqDeclarationTva");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public void checkDeclaration(Connection c, Date daty) throws Exception{
        DeclarationTva[] decls = (DeclarationTva[]) CGenUtil.rechercher(new DeclarationTva(), null, null, c, " AND DATE '"+daty+"' BETWEEN datyDebut AND datyFin");
        if(decls.length>0){
            throw new Exception("Le TVA du date "+daty+" est d\u00E9ja declar\u00E9");
        }
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        this.setEtat(1);
        if (this.getDatydebut().after(this.getDatyfin())) {
            throw new Exception("La date de d\u00E9but doit \u00EAtre inf\u00E9rieure ou \u00E9gale \u00E0 la date de fin");
        }
        checkDeclaration(c, this.getDatydebut());
        checkDeclaration(c, this.getDatyfin());
        return super.createObject(u, c);
    }

    public ComptaSousEcritureLib [] getTvaByDate(Connection c, Date datedebut, Date datefin, String codeimpot) throws Exception{
        LiaisonCodeImpot [] liaisons = (LiaisonCodeImpot[]) CGenUtil.rechercher(new LiaisonCodeImpot(), null, null, c, " AND IDCODEIMPOT='"+codeimpot+"'");
        String [] ids = new String[liaisons.length];
        for(int i=0;i<liaisons.length;i++){
            ids[i]=liaisons[i].getIdcompte();
        }
        if(ids.length==0){
            return new ComptaSousEcritureLib[0];
        }
        int moisDebut = Utilitaire.getMois(datedebut);
        int anneeDebut = Utilitaire.getAnnee(datedebut);
        String awhere = " AND MOISDECLARATION=" + moisDebut +
                " AND EXERCICE = " + anneeDebut +
                " AND compte IN (" + Utilitaire.tabToString(ids, "'", ",") + ")";
        System.err.println(awhere);
        ComptaSousEcritureLib temp = new ComptaSousEcritureLib();
        temp.setNomTable("ECRITURE_IMPOT");
        return (ComptaSousEcritureLib[]) CGenUtil.rechercher(temp, null, null, c,awhere);
    }

    public boolean taxable(Connection c,ComptaSousEcritureLib sousEcr) throws Exception{
        ComptaSousEcriture[] tabs = (ComptaSousEcriture[]) CGenUtil.rechercher(new ComptaSousEcriture(), null, null, c," AND IDMERE='"+sousEcr.getIdMere()+"' AND COMPTE like '445%'");
        return tabs.length > 0;
    }

    public ComptaSousEcritureLib getSousEcrTva(Connection c,ComptaSousEcritureLib sousEcr) throws Exception{
        ComptaSousEcritureLib[] tabs = (ComptaSousEcritureLib[]) CGenUtil.rechercher(new ComptaSousEcritureLib(), null, null, c," AND IDMERE='"+sousEcr.getIdMere()+"' AND COMPTE like '445%'");
        if(tabs.length>0){
            return tabs[0];
        }
        return new ComptaSousEcritureLib();
    }

    public ComptaSousEcritureLib [] enleverNonTaxable(Connection c, ComptaSousEcritureLib[] tabs) throws Exception{
        List<ComptaSousEcritureLib> liste = new ArrayList<>();
        for (int i = 0; i < tabs.length; i++) {
            if(taxable(c,tabs[i])){
                ComptaSousEcritureLib tva = this.getSousEcrTva(c,tabs[i]);
                if(tva.getCompte().compareToIgnoreCase(tabs[i].getCompte())!=0){
                    //liste.add(tva);
                }
                liste.add(tabs[i]);
            }
        }
        return liste.toArray(new ComptaSousEcritureLib[0]);
    }
    public ComptaSousEcritureLib [] enleverTaxable(Connection c, ComptaSousEcritureLib[] tabs) throws Exception{
        List<ComptaSousEcritureLib> liste = new ArrayList<>();
        for (int i = 0; i < tabs.length; i++) {
            if(!taxable(c,tabs[i])){
                liste.add(tabs[i]);
            }
        }
        return liste.toArray(new ComptaSousEcritureLib[0]);
    }

    public double getMountByCode(Connection c, Date datedebut,String codeimpot) throws Exception{
        LiaisonCodeImpot [] liaisons = (LiaisonCodeImpot[]) CGenUtil.rechercher(new LiaisonCodeImpot(), null, null, c, " AND IDCODEIMPOT='"+codeimpot+"'");
        String [] ids = new String[liaisons.length];
        if(ids.length==0){
            return 0;
        }
        double resultat = 0;
        for(int i=0;i<liaisons.length;i++){

            int moisDebut = Utilitaire.getMois(datedebut);
            int anneeDebut = Utilitaire.getAnnee(datedebut);
            String awhere = " AND MOISDECLARATION=" + moisDebut +
                    " AND EXERCICE = " + anneeDebut +
                    " AND compte = '"+liaisons[i].getIdcompte()+"'";
            System.err.println("====="+ awhere);
            ComptaSousEcritureLib temp = new ComptaSousEcritureLib();
            temp.setNomTable("COMPTASOUSECRITUREDECLARER");

            ComptaSousEcritureLib[] tabsOld = (ComptaSousEcritureLib[]) CGenUtil.rechercher(temp, null, null, c,awhere);

            ComptaSousEcritureLib [] tabs = null;
            if(liaisons[i].getTaxable()!=null && liaisons[i].getTaxable().compareToIgnoreCase("1")==0){
                System.out.println("================+TAXABLE"+liaisons[i].getIdcodeimpot());
                tabs = enleverNonTaxable(c,tabsOld);
            }else if(liaisons[i].getTaxable()!=null && liaisons[i].getTaxable().compareToIgnoreCase("0")==0){
                tabs = enleverTaxable(c,tabsOld);
            }
            System.err.println(liaisons[i].getTaxable()+"=========="+tabsOld.length+"========="+liaisons[i].getFormule());
            if(tabs!=null && tabs.length>0){
                System.err.println("==================="+tabs.length);
                if(liaisons[i].getFormule()!=null && liaisons[i].getFormule().compareToIgnoreCase("credit")==0){
                    System.err.println(liaisons[i].getFormule()+"========"+tabs.length);
                    resultat += AdminGen.calculSommeDouble(tabs,"credit");
                }else if(liaisons[i].getFormule()!=null && liaisons[i].getFormule().compareToIgnoreCase("debit")==0){
                    System.err.println(liaisons[i].getFormule()+"========"+tabs.length);
                    resultat += AdminGen.calculSommeDouble(tabs,"debit");
                }else if(liaisons[i].getFormule()!=null && liaisons[i].getFormule().compareToIgnoreCase("credit-debit")==0){
                    System.err.println(liaisons[i].getFormule()+"========"+tabs.length);
                    resultat += AdminGen.calculSommeDouble(tabs,"credit") - AdminGen.calculSommeDouble(tabs,"debit");
                }else if(liaisons[i].getFormule()!=null && liaisons[i].getFormule().compareToIgnoreCase("debit-credit")==0){
                    System.err.println(liaisons[i].getFormule()+"========"+tabs.length);
                    resultat += AdminGen.calculSommeDouble(tabs,"debit") - AdminGen.calculSommeDouble(tabs,"credit");
                }
            }
        }
        return resultat;
    }

    public HashMap<String,ImprimerDeclaration> calculer(Date datedebut, Date datefin) throws Exception{
        Connection c = null;
        int verif = 0;
        try{
            if(c == null){
                c = new UtilDB().GetConn();
                verif = 1;
            }
            ImprimerDeclaration imp = new ImprimerDeclaration();
            ImprimerDeclaration[] imps = (ImprimerDeclaration[]) CGenUtil.rechercher(imp, null, null, c, " ORDER BY id asc");
            HashMap<String,ImprimerDeclaration> res = new HashMap<>();
            for(int i=0;i<imps.length;i++){
                imps[i].setMontant(getMountByCode(c,datedebut,imps[i].getNumero()));
                //ComptaSousEcritureLib [] sousEcritureLibs = getMountByCode(c,datedebut, imps[i].getNumero());
                //if(sousEcritureLibs.length>0){
                //    imps[i].setMontant(AdminGen.calculSommeDouble(sousEcritureLibs,"credit")-AdminGen.calculSommeDouble(sousEcritureLibs,"debit"));
                //}else{
                //    imps[i].setMontant(0);
                //}
                res.put(imps[i].getNumero(), imps[i]);
            }
            return res;
        }catch(Exception e){
            throw e;
        }finally{
            if(c != null && verif == 1) c.close();
        }
    }

    public void calculerSomme() throws Exception{
        HashMap<String,ImprimerDeclaration> res = this.getDonnees();
        res.get("150").setMontant(res.get("102").getMontant()+res.get("103").getMontant()+res.get("105").getMontant()+res.get("106").getMontant()+res.get("107").getMontant()+res.get("108").getMontant()+res.get("115").getMontant()+res.get("125").getMontant()+res.get("140").getMontant());
        res.get("161").setMontant(res.get("155").getMontant()+res.get("160").getMontant());
        res.get("170").setMontant(res.get("100").getMontant()+res.get("102").getMontant()+res.get("103").getMontant()+res.get("105").getMontant()+res.get("106").getMontant()+res.get("107").getMontant()+res.get("108").getMontant()+res.get("130").getMontant()+res.get("140").getMontant()+res.get("161").getMontant()+res.get("165").getMontant());
        res.get("200").setMontant(res.get("102").getMontant()*0.05);
        res.get("205").setMontant(res.get("103").getMontant()*0.2);
        res.get("210").setMontant(res.get("150").getMontant()*0.2);
        res.get("271").setMontant(res.get("140").getMontant()*0.2);
        res.get("274").setMontant(res.get("271").getMontant()+res.get("272").getMontant()+res.get("273").getMontant());
        res.get("275").setMontant(res.get("200").getMontant()+res.get("205").getMontant()+res.get("210").getMontant()+res.get("270").getMontant()+res.get("273").getMontant());
        res.get("310").setMontant(res.get("300").getMontant()+res.get("305").getMontant());
        res.get("360").setMontant(res.get("315").getMontant()+res.get("316").getMontant()+res.get("335").getMontant()+res.get("340").getMontant()+res.get("345").getMontant()+res.get("350").getMontant()+res.get("355").getMontant()+res.get("359").getMontant());
        res.get("365").setMontant(1.0);
        res.get("366").setMontant((res.get("360").getMontant()*res.get("365").getMontant())+res.get("338").getMontant());
        res.get("368").setMontant((res.get("320").getMontant()+res.get("330").getMontant()));
        res.get("370").setMontant((res.get("368").getMontant()*res.get("365").getMontant()));
        res.get("375").setMontant((res.get("310").getMontant()+res.get("366").getMontant()+res.get("370").getMontant()));
        res.get("400").setMontant((res.get("375").getMontant()-res.get("275").getMontant()));
        res.get("700").setMontant((res.get("275").getMontant()+res.get("620").getMontant())-(res.get("375").getMontant()+res.get("579").getMontant()+res.get("589").getMontant()+res.get("610").getMontant()+res.get("635").getMontant()+res.get("640").getMontant()));
        res.get("701").setMontant((res.get("610").getMontant()+res.get("400").getMontant()+res.get("579").getMontant()+res.get("589").getMontant()+res.get("640").getMontant())-(res.get("620").getMontant()+res.get("630").getMontant()+res.get("670").getMontant()));
        this.setDonnees(res);
    }

    public DeclarationTva() {
        this.setNomTable("DECLARATIONTVA");
    }

    public DeclarationTva(Date deatedebut, Date datefin) throws Exception{
        setDonnees(calculer(deatedebut,datefin));
        calculerSomme();
    }

    public ComptaSousEcriture[] getComptaSousEcritureByIds(String[] ids,Connection c) throws Exception {
        String awhere = " and id in (" + Utilitaire.tabToString(ids, "'", ",") + " ) order by id asc";
        return (ComptaSousEcriture[]) CGenUtil.rechercher(new ComptaSousEcriture(), null, null, c, awhere);
    }

    public ComptaEcriture genererEcritureMere(String libMere,String u, Connection c) throws Exception {
        ComptaEcriture mere = new ComptaEcriture();
        Date dateDuJour = Utilitaire.dateDuJourSql();
        int exercice = Utilitaire.getAnnee(dateDuJour);
        mere.setDaty(dateDuJour);
        mere.setDesignation(libMere);
        mere.setRemarque(libMere);
        mere.setExercice(""+exercice);
        mere.setDateComptable(dateDuJour);
        mere.setJournal(ConstanteStation.JOURNAL_OPERATION_DIVERS);
        String id = this.getId();
        String prefix = (id != null && id.length() >= 3) ? id.substring(0, 3) : id;
        mere.setOrigine(prefix);
        mere.setIdobjet(id);
        return (ComptaEcriture) mere.createObject(u, c);
    }

    public void saveSousEcriture(ComptaEcriture mere,ComptaSousEcriture[] filles, String u, Connection c) throws Exception {
        for (ComptaSousEcriture fille : filles) {
            fille.setIdMere(mere.getId());
            fille.setExercice(Utilitaire.getAnnee(Utilitaire.dateDuJourSql()));
            fille.setDaty(Utilitaire.dateDuJourSql());
            fille.setJournal(ConstanteStation.JOURNAL_OPERATION_DIVERS);
            if (fille.getDebit() > 0 || fille.getCredit() > 0) {
                fille.createObject(u, c);
            }
        }
    }

    public void genererEcritureDeductible(String[] ids, String u, Connection c) throws Exception{
        double somme = AdminGen.calculSommeDouble(this.getComptaSousEcritureByIds(ids,c),"debit");
        String libMere = "Somme TVA D&eacute;ductible";
        ComptaEcriture mere = genererEcritureMere(libMere,u,c);

        ComptaSousEcriture[] filles = new ComptaSousEcriture[2];
        filles[0] = new ComptaSousEcriture();
        String libSE1 ="&Eacute;tat, TVA &agrave; r&eacute;gulariser";
        filles[0].setLibellePiece(libSE1);
        filles[0].setRemarque(libSE1);
        filles[0].setCompte(ConstanteCompta.COMPTE_TVA_DEBIT);
        filles[0].setDebit(somme);

        filles[1] = new ComptaSousEcriture();
        String libSE2 ="TVA d&eacute;ductible";
        filles[1].setLibellePiece(libSE2);
        filles[1].setRemarque(libSE2);
        filles[1].setCompte(ConstanteCompta.COMPTE_TVA_DEDUCTIBLE);
        filles[1].setCredit(somme);
        this.saveSousEcriture(mere,filles,u,c);
    }

    public void genererEcritureCollecte(String[] ids, String u, Connection c) throws Exception{
        double somme = AdminGen.calculSommeDouble(this.getComptaSousEcritureByIds(ids,c),"credit");
        String libMere = "Somme TVA collect&eacute;";
        ComptaEcriture mere = genererEcritureMere(libMere,u,c);

        ComptaSousEcriture[] filles = new ComptaSousEcriture[2];
        filles[0] = new ComptaSousEcriture();
        String libSE1 ="&Eacute;tat, TVA &agrave; r&eacute;gulariser";
        filles[0].setLibellePiece(libSE1);
        filles[0].setRemarque(libSE1);
        filles[0].setCompte(ConstanteCompta.COMPTE_TVA_DEBIT);
        filles[0].setCredit(somme);

        filles[1] = new ComptaSousEcriture();
        String libSE2 ="TVA collect&eacute;";
        filles[1].setLibellePiece(libSE2);
        filles[1].setRemarque(libSE2);
        filles[1].setCompte(ConstanteCompta.COMPTE_TVA_COLLECTE);
        filles[1].setDebit(somme);
        this.saveSousEcriture(mere,filles,u,c);
    }

    public boolean existe(ComptaSousEcriture sous, ComptaSousEcriture [] liste) throws Exception{
        for (int i = 0; i < liste.length; i++) {
            if(liste[i].getId().compareToIgnoreCase(sous.getId())==0){
                return true;
            }
        }
        return false;
    }

    public void enregistrerSousEcritureDeclarer(String[] ids, String u, Connection c) throws Exception {
        ComptaSousEcriture [] sousEcrituresSansTva = this.getSousEcrSansTva(c);
        for (int i = 0; i < sousEcrituresSansTva.length; i++) {
            SousEcritureDeclarer sousEcritureDeclarer = new SousEcritureDeclarer();
            sousEcritureDeclarer.setIdSousEcriture(sousEcrituresSansTva[i].getId());
            Date debut = this.getDatydebut();
            Date fin = this.getDatyfin();
            int anneeDebut = Utilitaire.getAnnee(debut);
            int anneeFin = Utilitaire.getAnnee(fin);
            int moisDebut = Utilitaire.getMois(debut);
            int moisFin = Utilitaire.getMois(fin);
            if (anneeDebut != anneeFin || moisDebut != moisFin) {
                throw new Exception("Les dates de d\u00E9but et de fin doivent \u00EAtre dans le m\u00EAme mois et la m\u00EAme ann\u00E9e");
            }
            sousEcritureDeclarer.setMoisDeclaration(moisDebut);
            sousEcritureDeclarer.createObject(u,c);
            System.out.println("MIDITRA VOALOANY "+sousEcrituresSansTva[i].getId());
        }
        for (String id : ids) {
            ComptaSousEcriture sous = (ComptaSousEcriture) new ComptaSousEcriture().getById(id,"COMPTA_SOUS_ECRITURE",c);
            ComptaSousEcriture [] sousEcritures = (ComptaSousEcriture []) CGenUtil.rechercher(new ComptaSousEcriture(),null,null,c," AND IDMERE='"+sous.getIdMere()+"'");
            for (int i = 0; i < sousEcritures.length; i++) {
                SousEcritureDeclarer sousEcritureDeclarer = new SousEcritureDeclarer();
                sousEcritureDeclarer.setIdSousEcriture(sousEcritures[i].getId());
                Date debut = this.getDatydebut();
                Date fin = this.getDatyfin();
                int anneeDebut = Utilitaire.getAnnee(debut);
                int anneeFin = Utilitaire.getAnnee(fin);
                int moisDebut = Utilitaire.getMois(debut);
                int moisFin = Utilitaire.getMois(fin);
                if (anneeDebut != anneeFin || moisDebut != moisFin) {
                    throw new Exception("Les dates de d\u00E9but et de fin doivent \u00EAtre dans le m\u00EAme mois et la m\u00EAme ann\u00E9e");
                }
                sousEcritureDeclarer.setMoisDeclaration(moisDebut);
                if(!existe(sousEcritures[i],sousEcrituresSansTva)){
                    sousEcritureDeclarer.createObject(u,c);
                }
                System.out.println("MIDITRA "+sousEcritures[i].getId());
            }
        }
    }

    public ComptaSousEcritureLib [] getSousEcrSansTva(Connection c) throws Exception{
        LiaisonCodeImpot [] liaisons = (LiaisonCodeImpot[]) CGenUtil.rechercher(new LiaisonCodeImpot(), null, null, c, "");
        String [] ids = new String[liaisons.length];
        for(int i=0;i<liaisons.length;i++){
            ids[i]=liaisons[i].getIdcompte();
        }
        if(ids.length==0){
            return new ComptaSousEcritureLib[0];
        }

        String awhere = " AND DATY>=DATE '" + this.getDatydebut() +"'"+
                " AND DATY <= DATE '" + this.getDatyfin() +"'"+
                " AND compte IN (" + Utilitaire.tabToString(ids, "'", ",") + ")";
        System.err.println(awhere);
        ComptaSousEcritureLib temp = new ComptaSousEcritureLib();
        temp.setNomTable("COMPTASOUSECRITURESTVA");
        //Mila alana ilay misy tva
        return (ComptaSousEcritureLib[]) CGenUtil.rechercher(temp, null, null, c,awhere);
    }

    public String [] combinerIds(String [] id1, String [] id2){
        if (id1 == null) id1 = new String[0];
        if (id2 == null) id2 = new String[0];
        List<String> resultat = new ArrayList<>();
        for (String s1 : id1) {
            resultat.add(s1);
        }
        for (String s2 : id2) {
            boolean existe = false;
            for (String s1 : id1) {
                if (s1==s2) {
                    existe = true;
                    break;
                }
            }
            if (!existe) {
                resultat.add(s2);
            }
        }
        return resultat.toArray(new String[0]);
    }

    public void enregistrerDeclaration(String[] idsDeductible,String[] idsCollecte, String u, Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null){
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                canClose = true;
            }
            System.err.println();
            this.enregistrerSousEcritureDeclarer(combinerIds(idsDeductible,idsCollecte),u,c);
            this.createObject(u, c);
            //this.genererEcritureDeductible(idsDeductible,u,c);
            //this.genererEcritureCollecte(idsCollecte,u,c);
            if (canClose) {
                c.commit();
            }
        } catch (Exception e) {
            if (canClose) {
                c.rollback();
            }
            throw e;
        } finally {
            if (canClose) {
                c.close();
            }
        }
    }

    public double getMontantTvaCollectee(Connection c, int mois) throws Exception{
        try {
            ComptaSousEcritureLib o = new ComptaSousEcritureLib();
            o.setNomTable("COMPTASOUSECRITURETVA");
            ComptaSousEcriture [] tab = (ComptaSousEcriture []) CGenUtil.rechercher(o,null,null,c," AND MOISDECLARATION="+mois);
            return AdminGen.calculSommeDouble(tab,"credit");
        }catch (Exception ex){
            throw ex;
        }
    }

    public double getMontantTvaDeductible(Connection c, int mois) throws Exception{
        try {
            ComptaSousEcritureLib o = new ComptaSousEcritureLib();
            o.setNomTable("COMPTASOUSECRITURETVA");
            ComptaSousEcriture [] tab = (ComptaSousEcriture []) CGenUtil.rechercher(o,null,null,c," AND MOISDECLARATION="+mois);
            return AdminGen.calculSommeDouble(tab,"debit");
        }catch (Exception ex){
            throw ex;
        }
    }

    public ComptaSousEcriture[] genererSousEcritureCentre(Connection c) throws Exception{
        ComptaSousEcriture[] compta={};
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            int mois = Utilitaire.getMois(this.getDatydebut());
            double tvacollecte = getMontantTvaCollectee(c,mois);
            double tvadeductible = getMontantTvaDeductible(c,mois);
            compta = new ComptaSousEcriture[3];
            if((tvacollecte-tvadeductible)>0){
                int i=0;
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece("TVA collect&eacute;e");
                compta[i].setRemarque("TVA collect&eacute;e");
                compta[i].setCompte(ConstanteCompta.COMPTE_TVA_COLLECTE);
                compta[i].setDebit(tvacollecte);
                i++;
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece("TVA d&eacute;ductible");
                compta[i].setRemarque("TVA d&eacute;ductible");
                compta[i].setCompte(ConstanteCompta.COMPTE_TVA_DEDUCTIBLE);
                compta[i].setCredit(tvadeductible);
                i++;
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece("Etat TVA &agrave; payer");
                compta[i].setRemarque("Etat TVA &agrave; payer");
                compta[i].setCompte(ConstanteCompta.COMPTE_ETAT_TVA_PAYER);
                compta[i].setCredit((tvacollecte-tvadeductible));
            }else{
                int i=0;
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece("TVA collect&eacute;e");
                compta[i].setRemarque("TVA collect&eacute;e");
                compta[i].setCompte(ConstanteCompta.COMPTE_TVA_COLLECTE);
                compta[i].setDebit(tvacollecte);
                i++;
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece("TVA d&eacute;ductible");
                compta[i].setRemarque("TVA d&eacute;ductible");
                compta[i].setCompte(ConstanteCompta.COMPTE_TVA_DEDUCTIBLE);
                compta[i].setCredit(tvadeductible);
                i++;
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece("Cr&eacute;dit TVA");
                compta[i].setRemarque("Cr&eacute;dit TVA");
                compta[i].setCompte(ConstanteCompta.COMPTE_ETAT_TVA_CREDIT);
                compta[i].setDebit(Math.abs((tvacollecte-tvadeductible)));
                System.err.println("==============TTTTTTTTTTTTTTTTTAZA==================="+(tvacollecte-tvadeductible));
            }
        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
        return compta;
    }

    public void genererEcritureCentre(String u, Connection c) throws Exception{
        ComptaEcriture mere = new ComptaEcriture();
        Date dateDuJour = Utilitaire.dateDuJourSql();
        int exercice = Utilitaire.getAnnee(dateDuJour);
        mere.setDaty(dateDuJour);
        mere.setDesignation(this.getDesignation());
        mere.setExercice(""+exercice);
        mere.setDateComptable(dateDuJour);
        mere.setJournal(ConstanteCompta.journalOD);
        mere.setOrigine(this.getId());
        mere.setIdobjet(this.getId());
        mere.createObject(u, c);

        ComptaSousEcriture[] filles = this.genererSousEcritureCentre(c);
        for(int i=0; i<filles.length; i++){
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(dateDuJour);
            filles[i].setJournal(ConstanteCompta.journalOD);

            if(filles[i].getDebit()>0 || filles[i].getCredit()>0) filles[i].createObject(u, c);
        }
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        /*
        ImprimerDeclaration[] imps = (ImprimerDeclaration[]) CGenUtil.rechercher(new ImprimerDeclaration(), null, null, c, " ORDER BY id asc");
        for (ImprimerDeclaration imprimerDeclaration : imps) {
            ComptaSousEcritureLib[] sousEcritureLibs = getTvaByDate(c, this.getDatydebut(), this.getDatyfin(), imprimerDeclaration.getNumero());
            for (ComptaSousEcritureLib sousEcritureLib : sousEcritureLibs) {
                ComptaEcriture[] comptaEcriture = (ComptaEcriture[]) CGenUtil.rechercher(new ComptaEcriture(),null,null,c," AND id = '"+sousEcritureLib.getIdMere()+"'");
                if (comptaEcriture.length < 1) {
                    throw new Exception("Aucune \u00E9criture trouv\u00E9");
                }
                if (comptaEcriture[0].getEtat() == ConstanteEtat.getEtatCreer()) {
                    comptaEcriture[0].validerObject(u,c);
                    sousEcritureLib.validerObject(u,c);
                }
            }
        }
         */
        this.genererEcritureCentre(u,c);
        return super.validerObject(u, c);
    }

    public void genererEcritureAPayer(double montant, String compteBanque, String u, Connection c) throws Exception{
        String libMere = "TVA &agrave; payer";
        ComptaEcriture mere = genererEcritureMere(libMere,u,c);
        ComptaSousEcriture[] filles = new ComptaSousEcriture[2];

        filles[0] = new ComptaSousEcriture();
        String libSE1 ="TVA &agrave; r&eacute;gulariser";
        filles[0].setCompte(compteBanque);
        filles[0].setLibellePiece(libSE1);
        filles[0].setRemarque(libSE1);
        filles[0].setCredit(montant);

        filles[1] = new ComptaSousEcriture();
        String libSE2 ="Paiement TVA";
        filles[1].setLibellePiece(libSE2);
        filles[1].setRemarque(libSE2);
        filles[1].setCompte(ConstanteCompta.COMPTE_TVA_DEBIT);
        filles[1].setDebit(montant);

        this.saveSousEcriture(mere,filles,u,c);
    }

    public FactureDeclaration genererFactureDeclaration() throws Exception {
        FactureDeclaration facture = new FactureDeclaration();
        facture.setIdFournisseur(ConstanteCompta.idFiscale);
        facture.setIdModePaiement(ConstanteCompta.MODE_PAIEMENT_ESPECE);
        facture.setDaty(Utilitaire.dateDuJourSql());
        facture.setDesignation("Facture d&eacute;claration : "+this.getId());
        facture.setDateEcheancePaiement(Utilitaire.dateDuJourSql());
        int annee = Utilitaire.getAnnee(facture.getDaty());
        int mois = Utilitaire.getMois(facture.getDaty());
        facture.setReference("REF-TVA-"+mois+"-"+annee);
        facture.setDevise("AR");
        facture.setIdDevise("AR");
        facture.setTaux(1);
        facture.setIdMagasin(ConstanteStation.getFichierCentre());
        facture.setEstPrevu(0);
        facture.setTypeachat("LOCAL");
        facture.setIdtypefacture(ConstanteCompta.TYPE_FACTURE_PRINCIPAL);
        facture.setIdObjet(this.getId());
        return facture;
    }

    public FactureDeclarationDetails[]  genererDeclarationDetails(Connection c, FactureDeclaration facture) throws Exception {
        FactureDeclarationDetails detail = new FactureDeclarationDetails();
        detail.setIdProduit(ConstanteCompta.idTva);
        detail.setIdFactureFournisseur(facture.getId());
        int mois = Utilitaire.getMois(this.getDatydebut());
        double collecte = this.getMontantTvaCollectee(c,mois);
        double deductible = this.getMontantTvaDeductible(c,mois);
        double val = collecte-deductible;
        detail.setPu(Math.abs(val));
        if(val<0){
            detail.setIdbcDetail("CREDIT");
            facture.setIdBc("CREDIT");
        }
        detail.setIdDevise("AR");
        detail.setTauxDeChange(1);
        detail.setDesignation("Facture d&eacute;claration : "+this.getId());
        detail.setMois(Utilitaire.getMois(Utilitaire.dateDuJourSql()));
        detail.setAnnee(Utilitaire.getAnnee(Utilitaire.dateDuJourSql()));
        detail.setQte(1);
        FactureDeclarationDetails[] details = new FactureDeclarationDetails[1];
        details[0] = detail;
        return details;
    }

    public double getMontantFactureDeclaration(Connection c) throws Exception {
        ComptaEcriture ecriture = new ComptaEcriture();
        ecriture.setIdobjet(this.getId());
        ComptaEcriture[] ecritures = (ComptaEcriture[]) CGenUtil.rechercher(ecriture,null,null,c,"");
        double montant = 0;
        for (ComptaEcriture e : ecritures) {
            ComptaSousEcriture se = new ComptaSousEcriture();
            se.setIdMere(e.getId());
            ComptaSousEcriture[] sousEcritures = (ComptaSousEcriture[]) CGenUtil.rechercher(se,null,null,c,"");
            for (int i = 0; i < sousEcritures.length; i++) {
                if(sousEcritures[i].getCompte().compareToIgnoreCase(ConstanteCompta.COMPTE_TVA_COLLECTE)==0){ //Vente
                    montant += AdminGen.calculSommeDouble(sousEcritures,"debit");
                }else if(sousEcritures[i].getCompte().compareToIgnoreCase(ConstanteCompta.COMPTE_TVA_DEDUCTIBLE)==0){ //Achat
                    montant -= AdminGen.calculSommeDouble(sousEcritures,"credit");
                }
            }
        }
        return montant;
    }

    public void checkPaiement(Connection c) throws Exception{
        FactureDeclaration [] factures = (FactureDeclaration []) CGenUtil.rechercher(new FactureDeclaration(), null,null, c, " AND IDOBJET='"+this.getId()+"'");
        if(factures.length>0){
            throw new Exception("D\u00E9claration TVA d\u00E9j\u00E0 pay\u00E9");
        }
    }

    public FactureDeclaration genererFactureDeclaration(String u, Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            DeclarationTva decl = (DeclarationTva) new DeclarationTva().getById(this.getId(),"DECLARATIONTVA",c);
            this.checkPaiement(c);
            FactureDeclaration facture = decl.genererFactureDeclaration();
            facture.construirePK(c);
            FactureDeclarationDetails[] details = decl.genererDeclarationDetails(c,facture);
            facture.setFille(details);
            FactureDeclaration result = (FactureDeclaration) facture.createObject(u,c);
            result.validerObject(u,c);
            return (FactureDeclarationCpl)new FactureDeclarationCpl().getById(result.getId(),"FactureDeclarationCpl",c);
        } catch (Exception e) {
            if (canClose) c.rollback();
            throw e;
        } finally {
            if (canClose) c.close();
        }
    }
}

