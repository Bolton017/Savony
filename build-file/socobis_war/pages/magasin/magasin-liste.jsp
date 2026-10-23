<%@page import="magasin.Magasin"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="affichage.Liste" %>
<%@ page import="prevision.Service" %>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    Magasin magasin = new Magasin();
    magasin.setNomTable("magasinlib");
    String listeCrt[] = {"id", "val","desce","idpointlib","idTypeMagasinlib","idDepartement"};
    String listeInt[] = {};
    String libEntete[] = {"id", "val","desce","idpointlib","idTypeMagasinlib", "idDepartementLib"};
    PageRecherche pr = new PageRecherche(magasin, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des magasins");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("magasin/magasin-liste.jsp");

    Liste[] listes = new Liste[3];
    TypeObjet idTypeMagasinlib = new TypeObjet();
    idTypeMagasinlib.setNomTable("TYPEMAGASIN");
    listes[0] = new Liste("idTypeMagasinlib", idTypeMagasinlib, "val", "val");
    listes[1] = new Liste("idDepartement", new Service(), "libelle", "id");
    TypeObjet idpointlib = new TypeObjet();
    idpointlib.setNomTable("point");
    listes[2] = new Liste("idpointlib", idpointlib, "val", "val");
    pr.getFormu().changerEnChamp(listes);

    pr.getFormu().getChamp("id").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("desce").setLibelle("D&eacute;scription");
    pr.getFormu().getChamp("idpointlib").setLibelle("Point");
    pr.getFormu().getChamp("idTypeMagasinlib").setLibelle("Type");
    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=magasin/magasin-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=magasin/magasin-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence", "Libell&eacute;","D&eacute;scription","Point","Type", "D&eacute;partement"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=magasin/magasin-saisie.jsp&currentMenu=MNDN0000000201\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un magasin</a>"
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
</div>
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



