<%@ page import="rapport.mapping.MailRapport" %>
<%@ page import="affichage.PageRecherche" %>
<%
    try{

        MailRapport mailRapport = new MailRapport();

        String[] listCrt = {"id", "val"};
        String[] listInt = {};
        String[] libEntete = {"id", "val", "desce"};
        String[] libEnteteAffiche = {"Id", "E-Mail", "Description"};

        PageRecherche pr = new PageRecherche(mailRapport, request, listCrt, listInt, 3, libEntete, libEntete.length);
        pr.setTitre("Liste des Destinataires/Cc");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("rapport/configuration/mailrapport/mailrapport-liste.jsp");

        pr.getFormu().getChamp("val").setLibelle("E-Mail");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=rapport/configuration/mailrapport/mailrapport-fiche.jsp"};
        String colonneLien[] = {"id"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

%>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="depense" id="depense">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch (Exception e){
        e.printStackTrace();
    }
%>