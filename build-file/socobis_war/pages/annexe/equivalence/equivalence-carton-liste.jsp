<%@page import="annexe.*"%>
<%@page import="affichage.PageRecherche"%>

<% try{
    EquivalenceLib t = new EquivalenceLib();
    t.setNomTable("EQUIVALENCECARTONLIB");
    String listeCrt[] = {"id","idPetrisLib","idCartonLib"};
    String listeInt[] = {""};
    String libEntete[] ={"id","idPetrisLib","idCartonLib","nbcarton"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Equivalence en carton");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("annexe/equivalence/equivalence-carton-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idPetrisLib").setLibelle("Morceau");
    pr.getFormu().getChamp("idCartonLib").setLibelle("Carton");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=annexe/equivalence/equivalence-carton-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id","Morceau", "Carton","Nombre de morceaux de savon dans un carton"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=annexe/equivalence/equivalence-carton-saisie.jsp&currentMenu=MNDN0000408002\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un equivalence en carton</a>"
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

