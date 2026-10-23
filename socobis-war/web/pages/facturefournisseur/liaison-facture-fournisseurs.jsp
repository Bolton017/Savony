

<%@ page import="faturefournisseur.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%
    try{
        LiaisonIntraTable a = new LiaisonIntraTable();
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        //Modification des affichages
        pi.getFormu().getChamp("id1").setLibelle("Facture Fournisseur");
        pi.getFormu().getChamp("id2").setLibelle("Frais Divers");
        pi.getFormu().getChamp("montant").setLibelle("Montant");
        pi.getFormu().getChamp("montant").setAutre("readonly");
        pi.getFormu().getChamp("montant").setVisible(false);
        pi.getFormu().getChamp("id1").setPageAppel("choix/facture/facturefournisseur-choix.jsp");
        pi.getFormu().getChamp("id2").setPageAppel("choix/facture/facturefournisseur-choixmultiple.jsp");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("id1").setAutre("readonly");
        pi.getFormu().getChamp("id2").setAutre("readonly");
        if(request.getParameter("id")!=null){
            pi.getFormu().getChamp("id1").setDefaut(request.getParameter("id"));
        }
        //Variables de navigation
        String classe = "faturefournisseur.LiaisonIntraTable";
        String butApresPost = "facturefournisseur/facturefournisseur-fiche.jsp";
        String nomTable = "LIAISONFACTUREFOURNISSEURS";
        //Generer les affichages
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Liaison Facture Fournisseur et Frais Divers</h1>
    <form action="<%=pi.getLien()%>?but=facturefournisseur/apres-facturefournisseur.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>

