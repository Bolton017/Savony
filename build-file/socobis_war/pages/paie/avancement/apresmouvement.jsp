<%--
    Document   : apresmouvement
    Created on : 29 sept. 2022, 10:12:50
    Author     :    Sambatra Rakotondrainibe
--%>

<%@page import="java.sql.Date"%>
<%@page import="user.*" %>
<%@page import="bean.*" %>
<%@page import="affichage.*" %>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="paie.avancement.PaieAvancement" %>
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String typeBoutton;
%>
<%
    try {
        typeBoutton = request.getParameter("type");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
        String classe = request.getParameter("classe");
        String tempRajout = request.getParameter("rajoutLien");
        String[] rajoutLien = null;
        String rajoutLie = "";
        ClassMAPTable t = null;
        String val = "";

        if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
            rajoutLien = utilitaire.Utilitaire.split(tempRajout, "-");
            if (rajoutLien != null) {
                for (int o = 0; o < rajoutLien.length; o++) {
                    String valeur = request.getParameter(rajoutLien[o]);
                    rajoutLie = rajoutLie + "&" + rajoutLien[o] + "=" + valeur;
                }
            }
        }

        if (bute == null || bute.compareToIgnoreCase("") == 0) {
            bute = "pub/Pub.jsp";
        }

        if (classe == null || classe.compareToIgnoreCase("") == 0) {
            classe = "pub.Montant";
        }

        if (typeBoutton == null || typeBoutton.compareToIgnoreCase("") == 0) {
            typeBoutton = "3"; //par defaut modifier
        }

        //if (acte.compareToIgnoreCase("mouvement") == 0 || acte.compareToIgnoreCase("deplacement") == 0) {
        if (acte.compareToIgnoreCase("insert") == 0) {
            try{
                Date dateDec = Utilitaire.stringDate(request.getParameter("datedecision"));
                Date dateAppl = Utilitaire.stringDate(request.getParameter("date_application"));
                if(dateDec==null||dateAppl==null){
                    throw new Exception("Date de decision supp�rieur et date application obligatoires");
                }
                if(Utilitaire.compareDaty(dateDec, dateAppl)>0){
                    throw new Exception("Date de decision supp�rieur a la date application");
                }
                PaieAvancement avancement = new PaieAvancement();
                avancement.setId_logpers(request.getParameter("id_logpers"));
                avancement.setMotif(request.getParameter("motif"));
                avancement.setDatedecision(Utilitaire.stringDate(request.getParameter("datedecision")));
                avancement.setRefdecision(request.getParameter("refdecision"));
                avancement.setDate_application(Utilitaire.stringDate(request.getParameter("date_application")));
                avancement.setDirection(request.getParameter("direction"));
                avancement.setRegion(request.getParameter("region"));
                avancement.setService(request.getParameter("service"));
                avancement.setIdfonction(request.getParameter("idfonction"));
                avancement.setMode_paiement(request.getParameter("mode_paiement"));
                avancement.setCtg(request.getParameter("ctg"));
                //if(request.getParameter("idcategorie")==null||request.getParameter("idcategorie").length()==0||request.getParameter("idcategorie").equals("null")) throw new Exception("Champ cat�gorie obligatoire");
                //avancement.setIdcategorie(request.getParameter("idcategorie"));
                //if(!request.getParameter("echelon").equals("0")){
                //avancement.setEchelon(Integer.parseInt(request.getParameter("echelon")));
                //}
                if(!request.getParameter("indicegrade").equals("0")){
                    avancement.setIndicegrade(Integer.parseInt(request.getParameter("indicegrade")));
                }
                avancement.setRemarque(request.getParameter("remarque"));
                avancement.setCode_banque(request.getParameter("code_banque"));
                ClassMAPTable mp = (ClassMAPTable)u.createObject(avancement);
                rajoutLie = "&id=" + mp.getTuppleID();
            }catch(Exception e){
                e.printStackTrace();
%>
<script language="JavaScript">alert('<%=e.getMessage()%>'); history.back();</script>
<%
        }
    }

    if(acte.compareToIgnoreCase("update") == 0){
        PaieAvancement avancement = new PaieAvancement();
        avancement.setId(request.getParameter("id"));
        avancement.setId_logpers(request.getParameter("id_logpers"));
        if(!request.getParameter("motif").equals("0")){
            avancement.setMotif(request.getParameter("motif"));
        }
        avancement.setDatedecision(Utilitaire.stringDate(request.getParameter("datedecision")));
        avancement.setRefdecision(request.getParameter("refdecision"));
        avancement.setDate_application(Utilitaire.stringDate(request.getParameter("date_application")));
        avancement.setDirection(request.getParameter("direction"));
        avancement.setService(request.getParameter("service"));
        avancement.setIdfonction(request.getParameter("idfonction"));
        avancement.setCtg(request.getParameter("ctg"));
        avancement.setIdcategorie(request.getParameter("idcategorie"));
        if(!request.getParameter("echelon").equals("0")){
            avancement.setEchelon(Integer.parseInt(request.getParameter("echelon")));
        }
        if(!request.getParameter("indicegrade").equals("0")){
            avancement.setIndicegrade(Integer.parseInt(request.getParameter("indicegrade")));
        }
        avancement.setRemarque(request.getParameter("remarque"));
        ClassMAPTable mp = (ClassMAPTable)u.updateObject(avancement);
        rajoutLie = "&id=" + mp.getTuppleID();
    }

            /*if (acte.compareToIgnoreCase("depart") == 0) {
                PaieAvancement avancement = new PaieAvancement();
                avancement.setId_logpers(request.getParameter("id_logpers"));
                avancement.setMotif(request.getParameter("motif"));
                avancement.setDatedecision(Utilitaire.stringDate(request.getParameter("datedecision")));
                avancement.setRefdecision(request.getParameter("refdecision"));
                avancement.setDate_application(Utilitaire.stringDate(request.getParameter("date_application")));
                ClassMAPTable mp = (ClassMAPTable)u.createObject(avancement);
            }*/

    if(acte.compareToIgnoreCase("valider")==0){
        t = (ClassMAPTable) (Class.forName(classe).newInstance());
        t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
        ClassMAPTable o = (ClassMAPTable) u.validerObject(t);
        rajoutLie = "&id=" + o.getTuppleID();
    }

    if(acte.compareToIgnoreCase("propositionavancement")==0){

    }

    if(acte.compareToIgnoreCase("delete")==0){
        try {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            t.setValChamp(t.getAttributIDName(), request.getParameter("id"));
            u.deleteObject(t);
            rajoutLie = "&id=" + request.getParameter("id");
        } catch (Exception e) {
            bute = request.getParameter("redirect");
%>
<script language="JavaScript">alert('<%=e.getMessage()%>');history.back();</script>
<%          }
}
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute + rajoutLie%>");</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');history.back();</script>
<%
        return;
    }
%>
</html>