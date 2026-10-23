<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="maintenance.ressources.PersonnelMaintenance" %>
<%@ page import="affichage.Liste" %>
<%@ page import="maintenance.ressources.DepartementMaintenance" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "maintenance.ressources.PersonnelMaintenance";
    String nomTable = "personnel";
    String apres = "maintenance/ressources/personnel/personnel-maintenance-fiche.jsp";

    PersonnelMaintenance o = new PersonnelMaintenance();
    o.setNomTable(nomTable);
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'un nouveau personnel");

    Liste[] liste = new Liste[1];
    DepartementMaintenance dep = new DepartementMaintenance();
    liste[0] = new Liste("idDepartement",dep,"val","id");

    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
    pi.getFormu().getChamp("nom").setLibelle("Nom et pr&eacute;noms");
    pi.getFormu().getChamp("telephone").setLibelle("T&eacute;l&eacute;phone");
    pi.getFormu().getChamp("mail").setLibelle("Adresse e-mail");
    pi.getFormu().getChamp("adresse").setLibelle("Adresse");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("compte").setVisible(false);
    pi.getFormu().getChamp("compte").setDefaut("OOOOO");

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modifiication d'un personnel");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1> <%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

