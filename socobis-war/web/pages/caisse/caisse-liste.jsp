

<%@page import="caisse.CaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="affichage.Liste" %>
<%@ page import="caisse.TypeCaisse" %>
<%@ page import="annexe.Point" %>
<%@ page import="caisse.CategorieCaisse" %>

<% try{
    CaisseCpl t = new CaisseCpl();
    String listeCrt[] = {"id", "val","desce","idTypeCaisseLib" , "idPointLib","idCategorieCaisseLib"};
    String listeInt[] = {};
    String libEntete[] = {"id", "val","desce","idTypeCaisseLib" , "idPointLib","idCategorieCaisseLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des caisses");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/caisse-liste.jsp");

    Liste[] liste = new Liste[3];
    TypeCaisse type = new TypeCaisse();
    type.setNomTable("TYPECAISSE");
    liste[0] = new Liste("idTypeCaisseLib",type,"val","val");
    Point point = new Point();
    point.setNomTable("point");
    liste[1] = new Liste("idPointLib",point,"val","val");
    CategorieCaisse categ = new CategorieCaisse();
    categ.setNomTable("CategorieCaisse");
    liste[2] = new Liste("idCategorieCaisseLib",categ,"val","val");

    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("id").setLibelle("Ref.");
    pr.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    pr.getFormu().getChamp("idTypeCaisseLib").setLibelle("Type");
    pr.getFormu().getChamp("idPointLib").setLibelle("Point");
    pr.getFormu().getChamp("idCategorieCaisseLib").setLibelle("Cat&eacute;gorie");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=caisse/caisse-modif.jsp");
    String classe = "caisse.Caisse";
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=caisse/caisse-liste.jsp&classe=" + classe);
    pr.getTableau().setLienClicDroite(lienTab);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=caisse/caisse-fiche.jsp", pr.getLien() + "?but=caisse/caisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    String[] attributLien = {"id", "id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Ref.", "D&eacute;signation", "Description","Type" , "Point","Cat&eacute;gorie"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=caisse/caisse-saisie.jsp\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie tr&eacute;sorerie</a>"
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



