<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="declaration.DeclarationTva" %>
<%@ page import="java.sql.Date" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="affichage.*" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "declaration.DeclarationTva";
    String nomTable = "DECLARATIONTVA";
    String apres = "declaration/tva-collecter-adeclarer.jsp";

    DeclarationTva o = new DeclarationTva();
    o.setNomTable("DECLARATIONTVA_VIDE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une d&eacute;claration Tva");

    affichage.Champ[] liste = new Champ[1];
    Liste mois = new Liste("mois");
    mois.makeListeMois();
    liste[0] = mois;
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("datydebut").setLibelle("Date de d&eacute;but");
    pi.getFormu().getChamp("datyfin").setLibelle("Date de fin");
    pi.getFormu().getChamp("mois").setLibelle("Mois");
    pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pi.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("datydebut").setVisible(false);
    pi.getFormu().getChamp("datyfin").setVisible(false);

    LocalDate today = LocalDate.now();
    LocalDate firstDayPrevMonth = today.minusMonths(1).withDayOfMonth(1);
    LocalDate lastDayPrevMonth  = today.minusMonths(1).withDayOfMonth(
        today.minusMonths(1).lengthOfMonth()
    );
    Date debut = Date.valueOf(firstDayPrevMonth);
    Date fin   = Date.valueOf(lastDayPrevMonth);
    pi.getFormu().getChamp("datydebut").setDefaut(Utilitaire.datetostring(debut));
    pi.getFormu().getChamp("datyfin").setDefaut(Utilitaire.datetostring(fin));


    String[] ordre = {"designation","datydebut","datyfin"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une d&eacute;claration Tva");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=declaration/tva-collecter-adeclarer.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
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
<script>
    (function () {
        var el = document.getElementById('annee');
        if (!el) return;
        ['onblur', 'oninput'].forEach(function (attr) {
            var v = el.getAttribute(attr);
            if (v) el.setAttribute(attr, v.replace(/formaterAvecSeparateurMillier\(this\);?\s*/g, ''));
        });
        el.value = el.value.replace(/\s/g, '');
    })();
</script>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

