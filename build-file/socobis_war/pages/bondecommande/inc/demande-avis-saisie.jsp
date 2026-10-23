<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="faturefournisseur.DemandeAvis" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try {
    UserEJB u = (user.UserEJB) session.getAttribute("u");
    String mapping = "faturefournisseur.DemandeAvis";
    String nomTable = "DEMANDEAVIS";
    String idObjet = request.getParameter("idObjet");
    String apres = request.getParameter("bute");

    DemandeAvis o = new DemandeAvis();
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getAttribute("lien"));
    pi.setTitre("Demande d'avis");

    pi.getFormu().getChamp("personneCible").setLibelle("Cible");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("heure").setLibelle("Heure");
    pi.getFormu().getChamp("heure").setType("time");
    pi.getFormu().getChamp("heure").setAutre("step=\"1\"");
    pi.getFormu().getChamp("demandeur").setVisible(false);
    pi.getFormu().getChamp("idObjet").setDefaut(idObjet);
    pi.getFormu().getChamp("idObjet").setVisible(false);
    pi.getFormu().getChamp("heure").setDefaut(Utilitaire.heureCouranteHM());
    pi.getFormu().getChamp("demandeur").setDefaut(u.getUser().getTuppleID());
    pi.getFormu().getChamp("personneCible").setPageAppelComplete("budget.UtilisateurService","refuserStr","UTILISATEURSTR");
 
    String[] ordre = {"demandeur","personneCible","daty","heure"};
    pi.getFormu().setOrdre(ordre);
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
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

