<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%/*@ page import="pub.*" */%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <%!
        UserEJB u = null;
        String acte = null;
        String lien = null;
        String bute;
        String nomtable = null;
        String val = null;
        String desce = null;
        int longuerClePrimaire = 3;

    %>
    <%

        try {
            lien = (String) session.getValue("lien");//System.out.println("ty ilay LIEN"+lien);
            u = (UserEJB) session.getAttribute("u");
            acte = request.getParameter("acte");
//            System.out.println("ty ilay ACTE"+acte);
            bute = request.getParameter("bute");
			System.out.println("ty ilay BUTE"+bute);
            nomtable = request.getParameter("nomtable");//System.out.println("ty ilay NOMTABLE"+nomtable);
            String INDICE_PK = nomtable.substring(0, 3).toUpperCase();//suffixe
            String nomProcedureSequence = "getSeq" + nomtable;//fonction sequence
            String[] lsMot =  nomProcedureSequence.split("_");
            nomProcedureSequence = "";
            for (String unMot : lsMot)
                nomProcedureSequence += unMot;
            val = request.getParameter("val");
            desce = request.getParameter("desce");
            System.out.println("ty ilay t1able"+nomtable+"         tsisy v");
            System.out.println("ty ilay nomProcedureSequence "+nomProcedureSequence+"         tsisy v");

            String[] rajoutLien = null;
            String tempRajout = request.getParameter("rajoutLien");
            String tableBdd = request.getParameter("tableBdd");
            if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
                //rajoutLien=utilitaire.Utilitaire.split(tempRajout,"-");
            }
            if (bute == null || bute.compareToIgnoreCase("") == 0) {
                bute = "pub/Pub.jsp";
            }

            String classe = request.getParameter("classe");//System.out.println("ty ilay CLASSE"+classe);
            ClassMAPTable t = null;
            //TypeObjet t=null;
            if (classe == null || classe.compareToIgnoreCase("") == 0) {
                classe = "pub.Montant";
            }
            
            if(nomProcedureSequence.compareTo("getSeqcomptaconventionprogramme")==0){
                INDICE_PK = "CPO";
            }else if(nomProcedureSequence.compareTo("getSeqcomptaplanbudgetaire")==0){
                INDICE_PK = "CBUDG";
            }
            
            if (acte.compareToIgnoreCase("insert") == 0) {
                u.createTypeObjet(nomtable, nomProcedureSequence, INDICE_PK, val, desce);
            }
            if (acte.compareToIgnoreCase("delete") == 0) {
                
                t = (ClassMAPTable) (Class.forName(classe).newInstance());
                t.setNomTable(nomtable);
                t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
                // System.out.println(" ========== localhost == " + t.getAttributIDName()+ " ==== "+request.getParameter("id"));
                //u.deleteObject(t);
                u.deleteTypeObjet(nomtable, t.getTuppleID());
                bute = bute + "&ciblename=" + nomtable;
            }
            if (acte.compareToIgnoreCase("update") == 0) {
                t = (ClassMAPTable) (Class.forName(classe).newInstance());
                t.setNomTable(nomtable);
                Page p = new Page(t, request);
                ClassMAPTable f = p.getObjectAvecValeur();
                f.setNomTable(nomtable);
                //u.updateObject(f);
                u.updateTypeObjet(nomtable, f.getTuppleID(), val, desce);
                // bute = "configuration/idvaldesce.jsp&ciblename=" + nomtable;
            }
            String rajoutLie = "";
            if (rajoutLien != null) {
                for (int o = 0; o < rajoutLien.length; o++) {
                    String valeur = request.getParameter(rajoutLien[o]);
                    rajoutLie = rajoutLie + "&" + rajoutLien[o] + "=" + valeur;
                }
            }
    %>
    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute + rajoutLie%>");</script>
    <%

    } catch (Exception e) {
        e.printStackTrace();
    %>

    <script language="JavaScript"> alert('<%=e.getMessage()%>');
              history.back();</script>
    <%
            return;
        }
    %>

</html>



