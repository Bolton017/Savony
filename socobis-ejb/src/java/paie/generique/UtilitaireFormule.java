/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.generique;


import bean.AdminGen;
import bean.CGenUtil;
import configuration.Configuration;
import paie.employe.PaieInfoPersEltPaieComplet;
import paie.employe.PaieInfoPersonnel;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;


/**
 *
 * @author tahina
 */
public class UtilitaireFormule {
    static ScriptEngine engine;
    static{
        if(engine==null)initialize();
    }
    
    private static void initialize(){
        try{
            System.out.println("---> IO FA MI IN//NITIALISZE");
            engine = new ScriptEngineManager().getEngineByName("JavaScript");
            //InputStream inputStream = UtilitaireFormule.class.getResourceAsStream("/JSEngine/engineJS.js");
            //String data = readFromInputStream(inputStream);
            
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
            e.printStackTrace();
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
            e.printStackTrace();
            throw e;
        }
        return retour;
    }

    public static String remplacerRubriqueParChiffre(PaieInfoPersonnel aCalc,String formule,ArrayList<PaieInfoPersEltPaieComplet> listeEltAInserer) throws Exception
    {
        String retour=formule.substring(0);
        try
        {
            String[] listeRub=getListeRubriqueTab(formule);
            
            for(String rub:listeRub)
            {
                String[]sousRub=rub.split("::");
                String valeur="0";
                if(sousRub.length>1) // Traitement Au cas ou info vient de pers
                {
                    if(sousRub[0].compareToIgnoreCase("Pers")==0||sousRub[0].compareToIgnoreCase("Personne")==0)
                    {
                        Object oval=CGenUtil.getValeurFieldByMethod(aCalc, sousRub[1]);
                        if (oval instanceof Number){
                            valeur=oval.toString();
                        }
                        else {
                            valeur="'"+oval.toString()+"'";
                        }
                    }
                    if(sousRub[0].compareToIgnoreCase("Conf")==0||sousRub[0].compareToIgnoreCase("Configuration")==0)
                    {
                        Configuration[] lConfig=PaieInfoPersonnel.getListeConfig();
                        String[] splitPointPoint=sousRub[1].split("\\.\\.");
                        String[] attrFiltre={"id"};
                        String[] attrValeur={splitPointPoint[0]};
                        Configuration conf=(Configuration)AdminGen.findUnique(lConfig, attrFiltre, attrValeur);
                        if(conf==null) throw new Exception("Configuration inexistante");
                        valeur=CGenUtil.getValeurFieldByMethod(conf,"min").toString();
                        if(splitPointPoint.length>1&&splitPointPoint[1].compareToIgnoreCase("max")==0) valeur=CGenUtil.getValeurFieldByMethod(conf,"max").toString();
                    }
                    
                }
                else if(rub.startsWith("++")) //Traitement de la somme [++imposable==I..gain]
                {
                    String reste=rub.substring(2);
                    String[] splitEgale=reste.split("==");
                    if(splitEgale.length>1)
                    {
                        String[] splitPointPoint=splitEgale[1].split("\\.\\.");
                        double[] gr=PaieInfoPersonnel.getValeurEltPaieInserable(listeEltAInserer, splitEgale[0], splitPointPoint[0]);
                        valeur=gr[0]+"";
                        if(splitPointPoint.length<=1)
                        {
                            valeur=(gr[0]-gr[1])+"";
                        }
                        else
                        {
                            if(splitPointPoint[1].compareToIgnoreCase("retenue")==0||splitPointPoint[1].compareToIgnoreCase("retenu")==0)valeur=gr[1]+"";
                        }
                    }
                }
                else // Traitement info vient de rubrique
                {
                    String[] splitPP=rub.split("\\.\\.");
                    if(splitPP.length>1)
                    {
                        ArrayList<PaieInfoPersEltPaieComplet> elmtP=PaieInfoPersonnel.getListeEltPaieInserable(listeEltAInserer, "code", splitPP[0]);
                        
                        if(elmtP.size()>0) 
                        {
                            valeur=CGenUtil.getValeurFieldByMethod(elmtP.get(0), splitPP[1]).toString();
                        }
                    }
                    else
                    {
                        double[] gainRetenue=PaieInfoPersonnel.getValeurEltPaie(listeEltAInserer, "code", rub);
                        valeur=gainRetenue[0]+"";
                        if(gainRetenue[0]<=0&&gainRetenue[1]>0) valeur=gainRetenue[1]+"";
                    }
                }
                
                //String aRemp="\\["+rub+"\\]";
                //retour=retour.replaceAll(aRemp, valeur+"");
                retour=retour.replace("["+rub+"]", valeur);
                
            }
            
        }
        catch(Exception e)
        {
            e.printStackTrace();
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
    
    public static String readFromInputStream(InputStream inputStream)throws IOException {
        StringBuilder resultStringBuilder = new StringBuilder();
        try (BufferedReader br
                = new BufferedReader(new InputStreamReader(inputStream))) {
            String line;
            while ((line = br.readLine()) != null) {
                resultStringBuilder.append(line).append("\n");
            }
        }
        return resultStringBuilder.toString();
    }
}
