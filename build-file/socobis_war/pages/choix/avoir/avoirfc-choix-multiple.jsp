<%@page import="avoir.AvoirFCLib"%>
<%@page import="affichage.PageRechercheChoix"%>
<%
    String champReturn = request.getParameter("champReturn");
    String idClient = request.getParameter("idClient");
    AvoirFCLib t = new AvoirFCLib();
    t.setNomTable("AVOIRFCLIB_CPL");
    String listeCrt[] = {"id", "clientlib", "idMagasinLib", "idorigine", "typeavoir", "idMotifLib" , "idCategorieLib", "daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "clientlib", "daty", "idMagasinLib", "idorigine", "typeavoir", "idMotifLib" , "idCategorieLib", "montantHT", "montantTVA", "montantTTC", "montantHTAr", "montantTVAAr", "montantTTCAr"};
    PageRechercheChoix pr = new PageRechercheChoix(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Choix Facture avoir");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("avoirfc-choix-multiple.jsp");
    pr.setChampReturn(champReturn);
     if(idClient != null && !idClient.trim().equals("")) {
        pr.setAWhere(" and idClient = '" + idClient + "'");
    }
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idMagasinLib").setLibelle("Magasin");
    //pr.getFormu().getChamp("idVenteLib").setLibelle("Vente");
    pr.getFormu().getChamp("idCategorieLib").setLibelle("Categorie");
    pr.getFormu().getChamp("idMotifLib").setLibelle("Motif");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("typeavoir").setLibelle("Type");
    pr.getFormu().getChamp("clientlib").setLibelle("Client");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=avoir/avoirFC-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Client", "Date", "Magasin", "Origine", "Type", "Motif" , "Cat&eacute;gorie", "montant HT", "montant TVA", "montant TTC", "montant HT Ar", "montant TVA Ar", "montant TTC Ar"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= pr.getTitre()%></title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <jsp:include page='./../../elements/css.jsp'/>
</head>
<body class="skin-blue sidebar-mini">
<div class="wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre()%></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getApres()%>?champReturn=<%=champReturn%>" method="post" name="fcdetailsliste" id="fcdetailsliste">
            <% out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <form action="./../apresChoixMultiple.jsp" method="post" name="frmchx" id="frmchx">
            <input type="hidden" name="champReturn" value="<%=pr.getChampReturn()%>">
            <% out.println(pr.getTableau().getHtmlWithMultipleCheckbox()); %>
<%--            <% out.println(pr.getTableau().getHtml()); %>--%>
        </form>
        <% out.println(pr.getBasPage());%>
    </section>
</div>
<jsp:include page='./../../elements/js.jsp'/>
</body>
</html>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("frmchx");
    if (form) {
        form.addEventListener("submit", function () {
            let total = 0;
            document.querySelectorAll("#frmchx input[type=checkbox]:checked").forEach(function (chk) {
                let row = chk.closest("tr");
                if (row) {
                    let cell = row.cells[14];
                    if (cell) {
                        let valeur = parseFloat(cell.textContent.replace(/\s/g, "").replace(",", "."));
                        if (!isNaN(valeur)) {
                            total += valeur;
                        }
                    }
                }
            });

            if (window.opener && !window.opener.closed) {
                let champTotal = window.opener.document.getElementById("totalRestePrincipal");
                if (champTotal) {
                    champTotal.textContent = total.toLocaleString("fr-FR");
                }

                let inputHidden = window.opener.document.getElementById("totalResteInput");
                if (inputHidden) {
                    inputHidden.value = total;
                }

                let champMontant = window.opener.document.getElementById("montant");
                if (champMontant) {
                    champMontant.value = total;
                }
            }
        });
    }
});
</script>
