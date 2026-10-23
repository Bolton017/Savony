<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="fabrication.equipe.Equipe" %>
<%@ page import="fabrication.equipe.CompositionEquipe" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getAttribute("u");
    String classeMere = "fabrication.equipe.Equipe";
    String classeFille = "fabrication.equipe.CompositionEquipe";
    String nomTableFille = "COMPOSITIONEQUIPE";
    String colonneMere = "idEquipe";
    String apres = "fabrication/equipe/equipe-fiche.jsp";

    Equipe mere = new Equipe();
    mere.setNomTable("EQUIPE");
    CompositionEquipe fille = new CompositionEquipe();
    fille.setNomTable("COMPOSITIONEQUIPE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getAttribute("lien"));


    pi.getFormu().getChamp("val").setLibelle("Val");
    pi.getFormu().getChamp("desce").setLibelle("Desce");

    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idEquipe"),"fabrication.equipe.Equipe","id","Equipe");
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idPersonnel"),"paie.log.LogPersonnel","id","LOG_PERSONNEL_V2");
    Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    Champ.setAutre(pi.getFormufle().getChampFille("idPoste"),"readonly");
    String idEquipes = request.getParameter("id");
    if(request.getParameter("acte")!=null&&request.getParameter("acte").equalsIgnoreCase("update")){
        if(idEquipes!=null) Champ.setDefaut(pi.getFormufle().getChampFille("idEquipe"),idEquipes);
        Champ.setAutre(pi.getFormufle().getChampFille("idEquipe"),"readonly");
    }
    pi.getFormufle().getChamp("daty_0").setLibelle("Date");
    pi.getFormufle().getChamp("idEquipe_0").setLibelle("&Eacute;quipe");
    pi.getFormufle().getChamp("idPersonnel_0").setLibelle("Personnel");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("idPoste_0").setLibelle("Poste");

    String[] colOrdre = {"id","daty","idEquipe","idPersonnel","remarque"};
    pi.getFormufle().setColOrdre(colOrdre);

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>
<script>
    const div = document.querySelector('.col-md-12.cardradius');
    if (div) {
        div.style.display = 'none';
    }
</script>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

