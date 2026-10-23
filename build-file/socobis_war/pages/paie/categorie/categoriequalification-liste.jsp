<%-- 
    Document   : projet-list
    Created on : 6 oct. 2020, 16:13:05
    Author     : mariano
--%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="paie.CategorieQualification"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<%
    try {
        CategorieQualification categorie = new CategorieQualification();
        categorie.setNomTable("categ_qualilibcomplet");
        //set table refaveo;
        
								
        String libEntete[] = {"id", "remarque","matricule","nomCpl", "idcategorie","idqualification" ,"date_debut","date_fin","montant","etatlibelle"};
        String listeCrt[] = {"id","remarque","matricule","nomCpl", "date_debut", "date_fin", "idcategorie","idqualification","etatlibelle","montant"};
        String listeInt[] = {"montant"};
        PageRecherche pr = new PageRecherche(categorie, request, listeCrt, listeInt, 6, libEntete, libEntete.length);
        
                
        affichage.Champ[] liste = new affichage.Champ[3];
        TypeObjet liste1 = new TypeObjet();
        liste1.setNomTable("etat_categ_qualif2");
        liste[0] = new Liste("etatlibelle",liste1,"val","desce");

        TypeObjet qualification = new TypeObjet();
        qualification.setNomTable("QUALIFICATION_PAIE");
        liste[1] = new Liste("idqualification", qualification, "val", "desce");

        TypeObjet categPaie = new TypeObjet();
        categPaie.setNomTable("CATEGORIE_PAIE");
        liste[2] = new Liste("idcategorie", categPaie, "val", "desce");
        pr.getFormu().changerEnChamp(liste);

        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("paie/categorie/categoriequalification-liste.jsp");
        
        //rename labels
        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("idcategorie").setLibelle("Cat&eacute;gorie");
        pr.getFormu().getChamp("idqualification").setLibelle("Qualification");
        pr.getFormu().getChamp("remarque").setLibelle("ID Personnel");
        pr.getFormu().getChamp("matricule").setLibelle("Matricule");
        pr.getFormu().getChamp("montant1").setLibelle("Montant min");
        pr.getFormu().getChamp("montant2").setLibelle("Montant max");
//        pr.getFormu().getChamp("date_debut1").setLibelle("Date debut min");
//        pr.getFormu().getChamp("date_fin1").setLibelle("Date fin min");
//        pr.getFormu().getChamp("date_debut2").setLibelle("Date debut max");
//        pr.getFormu().getChamp("date_fin2").setLibelle("Date fin max");
        pr.getFormu().getChamp("nomCpl").setLibelle("Nom Complet");
        pr.getFormu().getChamp("etatlibelle").setLibelle("&Eacute;tat");
        pr.getFormu().getChamp("date_debut").setLibelle("Date Debut");
        pr.getFormu().getChamp("date_debut").setDefaut(utilitaire.Utilitaire.dateDuJour() + "");
        pr.getFormu().getChamp("date_fin").setLibelle("Date Fin");
        pr.getFormu().getChamp("date_fin").setDefaut(utilitaire.Utilitaire.dateDuJour() + "");
        
        

//        pr.getFormu().getChamp("etatval").setLibelle("Etat");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des Cat&eacute;gorie/Qualification</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/categorie/categoriequalification-liste.jsp" method="post" name="categoriepaie" id="categoriepaie">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            String lienTableau[] = {pr.getLien() + "?but=paie/categorie/categoriequalification-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"ID", "ID Personnel","Matricule","Nom complet", "Cat&eacute;gorie","Qualification","Date de d&eacute;but","Date de fin","Montant","&Eacute;tat"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
    
</div>
    <style>
        tr td:first-child{
            text-align : left !important;
        }
        tr td:nth-child(2){
            text-align : left !important;
        }
    </style>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
