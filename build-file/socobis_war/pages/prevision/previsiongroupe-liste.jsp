<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="prevision.PrevisionComplet" %>

<% try{
    PrevisionComplet o = new PrevisionComplet();
    o.setNomTable("PREVISIONGROUPE");
    String[] listeCrt = {"debit","credit","idFacture","daty","reference"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"idFacture","daty","reference","debit","credit"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des pr&eacute;visions group&eacute;es");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("prevision/previsiongroupe-liste.jsp");
    pr.getFormu().getChamp("idFacture").setLibelle("Id Facture");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");

    String[] colSomme = {"debit","credit"};
    pr.creerObjetPage(libEntete, colSomme);


    String[] libEnteteAffiche = {"Id Facture","Date","R&eacute;f&eacute;rence","D&eacute;bit","Cr&eacute;dit"};

    String lienTableau[] = {pr.getLien() + "?but=prevision/reference-redirection.jsp"};
    String colonneLien[] = {"idFacture"};
    String valLien[] = {"reference","idFacture"};
    String varColonneLien[] = {"lien"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setValeurLien(valLien);
    pr.getTableau().setAttLien(varColonneLien);
    pr.getTableau().setColonneLien(colonneLien);

    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                String libelles[]={" ","Nombre","Somme des d&eacute;bits","Somme des cr&eacute;dits "};
                pr.getTableauRecap().setLibeEntete(libelles);
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    window.addEventListener("load", function() {
        const debit = document.getElementById("debit");
        const credit = document.getElementById("credit");

        if (debit) debit.remove();
        if (credit) credit.remove();

        const debitAuto = document.querySelector('input[name="debitauto"]');
        const creditAuto = document.querySelector('input[name="creditauto"]');

        if (debitAuto) {
            const parentDiv = debitAuto.closest('.form-input');
            if (parentDiv) parentDiv.remove();
        }

        if (creditAuto) {
            const parentDiv = creditAuto.closest('.form-input');
            if (parentDiv) parentDiv.remove();
        }
    });
</script>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

