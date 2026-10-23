<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="fabrication.CommentaireOF" %>
<%@ page import="historique.MapUtilisateur" %>
<%@ page import="paie.demande.EmployeComplet" %>

<% try{
    String idOF = request.getParameter("id");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "fabrication.CommentaireOF";
    String nomTable = "COMMENTAIREOF";
    String apres = "fabrication/ordre-fabrication-fiche.jsp&id="+idOF;


    CommentaireOF o = new CommentaireOF();
    o.setNomTable("COMMENTAIREOF");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un commentaire OF");

    pi.getFormu().getChamp("idObjet").setDefaut(idOF);
    //pi.getFormu().getChamp("idObjet").setAutre("readonly");
    pi.getFormu().getChamp("idObjet").setVisible(false);
    pi.getFormu().getChamp("val").setLibelle("Commentaire");
    pi.getFormu().getChamp("val").setType("textarea");
    //pi.getFormu().getChamp("idPersonnel").setVisible(false);
    String[] ordre = {"idObjet","val"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    MapUtilisateur map = u.getUser();
    pi.getFormu().getChamp("idPersonnel").setDefaut(map.getTuppleID());
    pi.getFormu().getChamp("idPersonnel").setVisible(false);
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

