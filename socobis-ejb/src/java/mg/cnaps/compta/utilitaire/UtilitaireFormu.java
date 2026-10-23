package mg.cnaps.compta.utilitaire;

import bean.AdminGen;
import bean.CGenUtil;
import mg.cnaps.compta.ComptaSousEcriture;

import java.util.ArrayList;
import java.util.List;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

public class UtilitaireFormu {

    static ScriptEngine engine;
    static{
        if(engine==null)initialize();
    }

    private static void initialize(){
        try{
            System.out.println("---> IO FA MI IN//NITIALISZE");
            engine = new ScriptEngineManager().getEngineByName("JavaScript");

            String data =   "function arrondiCnaps(montant) {\n" +
                    "    montant = montant+\"\"; \n" +
                    "    var retour = montant;\n" +
                    "    var d = parseFloat(montant);\n" +
                    "    var tab = montant.split(\".\");\n" +
                    "    if (tab.length > 1) {\n" +
                    "        var ap = tab[1];\n" +
                    "        ap = ap.substring(0, 2);\n" +
                    "        var a = parseInt(ap.charAt(0) + \"\");\n" +
                    "        var b = parseInt(ap.charAt(1) + \"\");\n" +
                    "        if(isNaN(b))b = 0;\n" +
                    "        if (b > 0 && a % 2 !== 0) {\n" +
                    "            a++;\n" +
                    "        } else if (b === 0 && a % 2 !== 0) {\n" +
                    "            a--;\n" +
                    "        }\n" +
                    "        if(a===10){\n" +
                    "           tab[0] =  parseInt(tab[0])+1;\n" +
                    "           a = 0;\n" +
                    "        }\n" +
                    "        retour = tab[0] + \".\" + a;\n" +
                    "    }\n" +
                    "    return String(retour).toString();\n" +
                    "}\n" +
                    ";";


            engine.eval(data);
            //          inputStream.close();

            String temp = String.valueOf(engine.eval("arrondiCnaps(\"123.70\")"));
            System.out.println("EVAL ARRONDI temp = " + temp);
        }catch(Exception e){
            e.printStackTrace();

        }
    }

    public static List<String> getListeRubrique(String formule) throws Exception
    {
        List<String> retour = null;
        try {
            retour = new ArrayList<>();

            if (formule.contains("[") || formule.contains("]")) {
                String temp = "";
                boolean encours = false;
                for (int i = 0; i < formule.length(); i++) {
                    if (formule.charAt(i) == '[' || encours) {
                        if (formule.charAt(i + 1) == ']') {
                            retour.add(temp);
                            temp = new String("");
                            encours = false;
                        } else {
                            encours = true;
                            temp += formule.charAt(i + 1);
                        }
                    }
                }
            }
        }
        catch (Exception e) {
            //e.printStackTrace();
            throw e;
        }
        return retour;
    }
    public static String[] getListeRubriqueTab(String formule) throws Exception {
        String[] retour = null;
        try {
            List<String> rep = getListeRubrique(formule);
            retour = new String[rep.size()];
            rep.toArray(retour);
        }
        catch (Exception e) {
            //e.printStackTrace();
            throw e;
        }
        return retour;
    }

    
    public static boolean isNatureDebit(String compte) {
        if (compte.startsWith("28") || compte.startsWith("29") || compte.startsWith("39")
                || compte.startsWith("49") || compte.startsWith("59") || compte.startsWith("519")) {
            return false;
        }
        if (compte.startsWith("2") || compte.startsWith("3") || compte.startsWith("5") || compte.startsWith("6")) {
            return true;
        }
        if (compte.startsWith("419") || compte.startsWith("4286")) {
            return false;
        }
        return compte.startsWith("409") || compte.startsWith("41") || compte.startsWith("422")
                || compte.startsWith("424") || compte.startsWith("425") || compte.startsWith("428")
                || compte.startsWith("486");
    }
    /* 
    public static String remplacerRubriqueParChiffre(ComptaSousEcriture[] aCalc, String formule) throws Exception
    {
        String retour = formule;
        try
        {
            String[] listeRub=getListeRubriqueTab(formule);

            for(String rub:listeRub)
            {
                System.err.println("==========++>"+rub);
                String valeur="0";
                String[] splitPP=rub.split("\\.\\.");
                ComptaSousEcriture[] cse = null;
                if(splitPP.length>1){
                    cse = (ComptaSousEcriture[]) AdminGen.find(aCalc,new String[]{"compte"},new String[]{splitPP[0]});
                }else
                    cse = (ComptaSousEcriture[]) AdminGen.find(aCalc,new String[]{"compte"},new String[]{rub});
                if(cse==null || cse.length==0){
                    retour=retour.replace("["+rub+"]", valeur);
                    continue;
                }
                System.out.println(splitPP.length+"==========>"+splitPP[0]);
                if(splitPP.length>1)
                {
                    System.out.println("=============+>"+splitPP[1]);
                    Object ob = CGenUtil.getValeurFieldByMethod(cse[0],splitPP[1]);
                    if (ob != null) {
                        valeur = ob.toString();
                    }
                }
                else
                {
                    Object ob = null;
                    if(cse[0].isActif()){
                        ob = CGenUtil.getValeurFieldByMethod(cse[0],"soldeActif");
                    }else{
                        ob = CGenUtil.getValeurFieldByMethod(cse[0],"solde");
                    }
                    System.err.println("======++>"+cse[0].getCompte()+"=====>"+rub+"========>"+ob);
                    if (ob != null) {
                        valeur = ob.toString();
                    }
                }
                retour=retour.replace("["+rub+"]", valeur);
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            throw e;
        }
        return retour.replaceAll("--", "-");
    }
    */
    public static String remplacerRubriqueParChiffre(ComptaSousEcriture[] aCalc, String formule) throws Exception
    {
        String retour = formule;
        String[] listeRub = getListeRubriqueTab(formule);
        for (String rub : listeRub) {
            String[] splitPP = rub.split("\\.\\.");
            String prefixe = splitPP[0].trim();
            double debit = 0, credit = 0;
            for (ComptaSousEcriture cse : aCalc) {
                if (cse.getCompte() != null && cse.getCompte().startsWith(prefixe)) {
                    debit += cse.getDebit();
                    credit += cse.getCredit();
                }
            }
            double solde = debit - credit;
            double valeur;
            if (splitPP.length > 1) {
                if (splitPP[1].equalsIgnoreCase("debit")) valeur = Math.max(solde, 0);
                else if (splitPP[1].equalsIgnoreCase("credit")) valeur = Math.max(-solde, 0);
                else valeur = solde;
            } else {
                valeur = isNatureDebit(prefixe) ? solde : -solde;
            }
            retour = retour.replace("[" + rub + "]", "(" + valeur + ")");
        }
        return retour;
    }

    public static double calculerFormule(String formuleSansRub) throws Exception
    {
        //ScriptEngineManager mgr = new ScriptEngineManager();
        //ScriptEngine engine = mgr.getEngineByName("JavaScript");
        if(formuleSansRub==null || formuleSansRub.compareTo("")==0) return 0;
        return Double.parseDouble(engine.eval(formuleSansRub).toString());
    }
    public static String evaluerFormule(String formuleSansRub) throws Exception
    {
        //ScriptEngineManager mgr = new ScriptEngineManager();
        //ScriptEngine engine = mgr.getEngineByName("JavaScript");

        if(formuleSansRub==null || formuleSansRub.compareTo("")==0) return "";
        return (engine.eval(formuleSansRub).toString());
    }
    public static boolean evaluerCondition(String formuleSansRub) throws Exception
    {
        //ScriptEngineManager mgr = new ScriptEngineManager();
        //ScriptEngine engine = mgr.getEngineByName("JavaScript");
        return ((Boolean)engine.eval(formuleSansRub)).booleanValue();
    }
}
