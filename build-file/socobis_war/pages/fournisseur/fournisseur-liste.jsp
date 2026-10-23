

<%@page import="faturefournisseur.Fournisseur"%>
<%@page import="affichage.PageRecherche"%>

<% try{ 
    Fournisseur t = new Fournisseur();
    String listeCrt[] = {"id", "nom","nif","stat" , "adresse","codePostal"};
    String listeInt[] = {};
    String libEntete[] = {"id", "nom","nif","stat" , "adresse","codePostal"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste fournisseur");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("fournisseur/fournisseur-liste.jsp");
     pr.getFormu().getChamp("codePostal").setLibelle("code postal");
    String[] colSomme = null;
    pr.setNpp(50);
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=fournisseur/fournisseur-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id", "nom","nif","stat" , "adresse","code postal"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=fournisseur/fournisseur-saisie.jsp&currentMenu=MNDN0000508005\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un fournisseur</a>"
    );
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



