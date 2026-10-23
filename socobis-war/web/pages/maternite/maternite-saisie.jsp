<%@page import="paie.Maternite"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>

<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "paie.Maternite",
            nomtable = "MATERNITE",
            apres = "maternite/maternite-fiche.jsp",
            titre = "Insertion Maternite";
    String acte = "insert";
    if (request.getParameter("acte") != null) acte = request.getParameter("acte");
    String autres = request.getParameter("autres");
    Maternite  mat = new Maternite();
    PageInsert pi = new PageInsert(mat, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idPersonnel").setPageAppelComplete("paie.log.LogPersonnelValide","id","v_personnel_maternite");
    pi.getFormu().getChamp("idPersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("dateDepartTheorique").setLibelle("Depart th&eacute;orique");
    pi.getFormu().getChamp("dateDepartReel").setLibelle("Depart r&eacute;el");
    pi.getFormu().getChamp("dateAccouchement").setLibelle("Date d'accouchement");
    pi.getFormu().getChamp("dateRetourTheorique").setLibelle("Retour th&eacute;orique");
    pi.getFormu().getChamp("dateRetourAjuste").setLibelle("Retour ajust&eacute;e");
    pi.getFormu().getChamp("dateFinAllaitement").setLibelle("date de fin d'allaitement");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("dpa").setLibelle("Date pr&eacute;vue d'accouchement");

    if (autres != null && autres.equalsIgnoreCase("departReel")){
        pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
        pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
        pi.getFormu().getChamp("dateDepartTheorique").setAutre("readonly");
        pi.getFormu().getChamp("dateAccouchement").setAutre("readonly");
        pi.getFormu().getChamp("dateRetourTheorique").setAutre("readonly");
        pi.getFormu().getChamp("dateRetourAjuste").setAutre("readonly");
        pi.getFormu().getChamp("dateFinAllaitement").setAutre("readonly");
        pi.getFormu().getChamp("remarque").setAutre("readonly");
        pi.getFormu().getChamp("dpa").setAutre("readonly");
    } else if (autres != null && autres.equalsIgnoreCase("departAccouchement")){
        pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
        pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
        pi.getFormu().getChamp("dateDepartTheorique").setAutre("readonly");
        pi.getFormu().getChamp("dateDepartReel").setAutre("readonly");
        pi.getFormu().getChamp("dateRetourTheorique").setAutre("readonly");
        pi.getFormu().getChamp("dateRetourAjuste").setAutre("readonly");
        pi.getFormu().getChamp("dateFinAllaitement").setAutre("readonly");
        pi.getFormu().getChamp("remarque").setAutre("readonly");
        pi.getFormu().getChamp("dpa").setAutre("readonly");
    } else if (autres != null && autres.equalsIgnoreCase("departAjuste")){
        pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
        pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
        pi.getFormu().getChamp("dateDepartTheorique").setAutre("readonly");
        pi.getFormu().getChamp("dateDepartReel").setAutre("readonly");
        pi.getFormu().getChamp("dateRetourTheorique").setAutre("readonly");
        pi.getFormu().getChamp("dateAccouchement").setAutre("readonly");
        pi.getFormu().getChamp("dateFinAllaitement").setAutre("readonly");
        pi.getFormu().getChamp("remarque").setAutre("readonly");
        pi.getFormu().getChamp("dpa").setAutre("readonly");
    } else if (autres != null && autres.equalsIgnoreCase("departFinAlignement")){
        pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
        pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
        pi.getFormu().getChamp("dateDepartTheorique").setAutre("readonly");
        pi.getFormu().getChamp("dateDepartReel").setAutre("readonly");
        pi.getFormu().getChamp("dateRetourTheorique").setAutre("readonly");
        pi.getFormu().getChamp("dateAccouchement").setAutre("readonly");
        pi.getFormu().getChamp("dateRetourAjuste").setAutre("readonly");
        pi.getFormu().getChamp("remarque").setAutre("readonly");
        pi.getFormu().getChamp("dpa").setAutre("readonly");
    }
    if (autres == null && request.getParameter("acte") ==null){
        pi.getFormu().getChamp("dateDepartReel").setVisible(false);
        pi.getFormu().getChamp("dateAccouchement").setVisible(false);
        pi.getFormu().getChamp("dateRetourAjuste").setVisible(false);
        pi.getFormu().getChamp("dateFinAllaitement").setVisible(false);
    }
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>
