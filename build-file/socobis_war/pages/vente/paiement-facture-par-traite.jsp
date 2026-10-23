

<%@ page import="utils.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="paiement.*" %>
<%@ page import="vente.*" %>
<%
    try{
        String idvente = request.getParameter("idvente");
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        LiaisonPaiement a = new LiaisonPaiement();
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        //Modification des affichages
        pi.getFormu().getChamp("id1").setLibelle("ID Facture Vente");
        pi.getFormu().getChamp("id2").setLibelle("ID Traite");
        pi.getFormu().getChamp("montant").setLibelle("Montant");
        pi.getFormu().getChamp("id2").setPageAppel("choix/facture/traite-choix-multiple.jsp");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("id1").setAutre("readonly");
        pi.getFormu().getChamp("id2").setAutre("readonly");
        pi.getFormu().getChamp("montant").setAutre("readonly");

        String[] ids = request.getParameterValues("ids");
        StringBuilder id1 = new StringBuilder();
        if (ids!=null){
            for (String id : ids) {
                id1.append(id).append(";");
            }
        }
        pi.getFormu().getChamp("id1").setDefaut(id1.toString());
        if (idvente != null) {
            pi.getFormu().getChamp("id1").setDefaut(idvente);
        }
        //Variables de navigation
        String classe = "vente.PaiementFacture";
        String butApresPost = "vente/vente-fiche.jsp";
        String nomTable = "paiementfacture";
        //Generer les affichages
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Paiement de facture par traite</h1>

    <form action="<%=pi.getLien()%>?but=vente/apres-paiement.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input type="hidden" id="idClient" name="idClient">
        <input name="acte" type="hidden" id="nature" value="paiement_facture">
        <input name="paiementPar" type="hidden" id="nature" value="traite">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var btnTraite = document.querySelector("input[name='choix'][onclick*='traite-choix-multiple.jsp']");

        if (btnTraite) {
            btnTraite.onclick = function () {
                var idClient = document.getElementById("idClient").value;
                var url = "choix/facture/traite-choix-multiple.jsp?"
                    + "&champReturn=id2;id2libelle"
                    + "&apresLienPageAppel=";

                pagePopUp(url);
            };
        }
    });
</script>
