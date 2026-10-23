
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="maintenance.planning.Planning" %>
<%@ page import="maintenance.configuration.TypeMaintenance" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "maintenance.planning.Planning",
                nomtable = "Planning",
                apres = "maintenance/planning/planning-fiche.jsp",
                titre = "Saisie de planning";
        if (request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
            titre = "Modification de planning";
        }
        Planning categorie = new Planning();
        PageInsert pi = new PageInsert(categorie, request, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] liste = new Liste[3];
        TypeMaintenance c = new TypeMaintenance();
        liste[0] = new Liste("idTypeMaintenance",c,"val","id");
        liste[1] = new Liste("estPeriodique");
        liste[1].makeListeOuiNon();
        TypeObjet tp = new TypeObjet();
        tp.setNomTable("UNITEMAINTENANCE");
        liste[2] = new Liste("unite",tp,"val","id");
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("refObjet").setLibelle("Description");
        pi.getFormu().getChamp("idMachine").setLibelle("&Eacute;l&eacute;ment");
        pi.getFormu().getChamp("idMachine").setPageAppelComplete("maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE_LIB","","");
        pi.getFormu().getChamp("idTypeMaintenance").setLibelle("Type de maintenance");
        pi.getFormu().getChamp("frequence").setLibelle("Fr&eacute;quence");
        pi.getFormu().getChamp("datedebut").setLibelle("Date de d&eacute;but");
        pi.getFormu().getChamp("datefin").setLibelle("Date de fin");
        pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
        pi.getFormu().getChamp("estPeriodique").setLibelle("Est p&eacute;riodique");
        pi.getFormu().getChamp("estPeriodique").setAutre("onChange=\"changeChamp()\"");
        pi.getFormu().getChamp("duree").setLibelle("dur&eacute;e");
        pi.getFormu().getChamp("duree").setType("time");
        pi.getFormu().getChamp("heure").setType("time");
        pi.getFormu().getChamp("duree").setAutre("step=\"1\"");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idSource").setVisible(false);
        pi.getFormu().getChamp("datefin").setVisible(false);

        pi.getFormu().setOrdre(new String[]{"id","datedebut","idTypeMaintenance","idMachine","estPeriodique","frequence","unite","heure","duree"});
        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<script>
    function changeChamp(){
        let champPeriodique = document.getElementById("estPeriodique");
        let frequence = document.getElementById("frequence");
        let unite = document.getElementById("unite");

        if (champPeriodique.value === "0"){
            frequence.value = "";
            frequence.setAttribute("readonly","");
            unite.value = "";
            unite.setAttribute("readonly","");
        }else {
            frequence.removeAttribute("readonly");
            unite.removeAttribute("readonly");
        }
    }
    changeChamp();
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
