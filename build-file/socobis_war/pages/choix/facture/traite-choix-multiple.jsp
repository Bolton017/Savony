<%@page import="avoir.AvoirFCLib"%>
<%@page import="affichage.PageRechercheChoix"%>
<%@ page import="facture.tr.Traite" %>
<%
    try {
        String champReturn = request.getParameter("champReturn");
        Traite base = new Traite();
        base.setNomTable("TRAITEMTTRESTE");
        String[] listeCrt = {"id","tiers", "banque", "daty", "dateEcheance","reference"};
        String[] listeInt = {"daty"};
        String[] libEntete = {"id","tiers", "banque","reference", "daty", "dateEcheance","montant","montantreste","etatversementlib"};

        PageRechercheChoix pr = new PageRechercheChoix(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Choix traite");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("traite-choix-multiple.jsp");
        pr.setChampReturn(champReturn);

        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("reference").setLibelle("r&eacute;f&eacute;rence");
        pr.getFormu().getChamp("tiers").setLibelle("Tiers");
        pr.getFormu().getChamp("banque").setLibelle("Banque");
        pr.getFormu().getChamp("daty1").setLibelle("Date min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        pr.getFormu().getChamp("dateEcheance").setLibelle("Date &eacute;ch&eacute;ance");
        pr.setOrdre(" order by tiers,dateEcheance asc");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        //Definition des lienTableau et des colonnes de lien
        String[] lienTableau = {pr.getLien() + "?but=facture/traite-fiche.jsp"};
        String[] colonneLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        String[] libEnteteAffiche = {"Id","Tiers", "banque","r&eacute;f&eacute;rence", "Date", "&Eacute;cheance","montant","montant restant","&eacute;tat du versement"};
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
                        let cell = row.cells[8];
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
<% } catch (Exception e) {
    e.printStackTrace();
}%>