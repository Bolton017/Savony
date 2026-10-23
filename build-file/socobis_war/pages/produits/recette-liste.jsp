
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="mg.allosakafo.produits.RecetteLib"%>
<%@page import="affichage.PageRecherche"%>

<% try{
    RecetteLib lv = new RecetteLib();
    
	String nomTable = "AS_RECETTE_LIBCOMPLET";
   
	
	
    String listeCrt[] = {"id","idproduits","libelleproduit","valunite","quantite","libelleingredient","pu"};
    String listeInt[] = {"quantite","pu"};
    String libEntete[] ={"id","idproduits","libelleproduit","valunite","quantite","libelleingredient","pu"};

    
    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
   
    
    pr.getFormu().getChamp("idproduits").setLibelle(" ID Produit");
 
    pr.getFormu().getChamp("valunite").setLibelle("Unit&eacute;");
   
    pr.getFormu().getChamp("quantite1").setLibelle("Quantit&eacute;s min");
    pr.getFormu().getChamp("quantite2").setLibelle("Quantit&eacute;s max");
    
    pr.getFormu().getChamp("libelleingredient").setLibelle("Ingredients");
     pr.getFormu().getChamp("libelleproduit").setLibelle("Nom Produit");
    pr.getFormu().getChamp("pu1").setLibelle("Prix Unitaire min");
    pr.getFormu().getChamp("pu2").setLibelle("Prix Unitaire max");
  
    
    
    
    pr.setApres("produits/recette-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>
<script>
    function changerDesignation() {
        document.incident.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste Recette</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=produits/recette-liste.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
		
        </form>
        
        <%  String lienTableau[] = {pr.getLien() + "?but=produits/recette-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"Id"," ID Produit","Nom Produit","Unit&eacute;","Quantit&eacute;s","Ingredients","Prix Unitaire"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());

        %>
    </section>
</div>
       <% }catch(Exception e){e.printStackTrace();} %>