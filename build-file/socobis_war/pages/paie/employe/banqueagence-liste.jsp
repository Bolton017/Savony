<%@page import="affichage.PageRecherche"%>
<%@page import="paie.employe.BanqueAgence"%>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    String nomtable = "Banque_agence";
    BanqueAgence t = new BanqueAgence();
    t.setNomTable(nomtable);

    String listeCrt[] = {"id", "nom", "idBanque"};
    String listeInt[] = {};
    String libEntete[] = {"id", "nom", "codeAgence", "idBanque"};

    String pageListe = "paie/employe/banqueagence-liste.jsp";
    String pageFiche = "paie/employe/banqueagence-fiche.jsp";

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des Banque Agence");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres(pageListe);

    Liste[] liste = new Liste[1];
    TypeObjet r = new TypeObjet();
    r.setNomTable("Banque");
    liste[0] = new Liste("idBanque", r,"val", "id");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("idBanque").setLibelle("Banque");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=" + pageFiche};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Nom", "Code Agence", "Banque"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
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
    }catch(Exception e){

        e.printStackTrace();
    }
%>

