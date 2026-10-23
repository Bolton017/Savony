

<%@page import="caisse.MvtCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>

<% try{ 
    MvtCaisseCpl t = new MvtCaisseCpl();
    t.setNomTable("MVTCAISSECPLORIGINE");
    String etat = request.getParameter("etat");
    if(etat == null) etat = "";
    t.setNomTable( t.getNomTable().concat(etat) );
    String listeCrt[] = {"id", "designation", "tiers","idOrigine", "daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "daty","designation", "tiers","idCaisseLib", "idOrigine" ,"credit","debit", "heure","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des mouvements de caisse avec ID Origine");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/mvt/mvtCaisse-origine-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idOrigine").setLibelle("ID Origine");

    String[] colSomme = {"credit","debit"};
    pr.creerObjetPage(libEntete, colSomme);
    
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=caisse/mvt/mvtCaisse-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=caisse/mvt/mvtCaisse-fiche.jsp",pr.getLien() + "?but=caisse/mvt/mvt-dispatch.jsp"};
    String colonneLien[] = {"id","idOrigine"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id","date", "d&eacute;signation", "Tiers","Caisse", "ID origine" ,"Entr&eacute;e de caisse","Sortie de caisse", "Heure","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatAffiche = {"Tous","Cr&eacute;&eacute;(s)","&Agrave; Comptabliser","Valid&eacute;(s)","Annul&eacute;(s)"};
    String[] etatPasse = {"","_cree","_a","_valider","_annule"};
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=caisse/mvt/mvtCaisse-saisie-entree.jsp&currentMenu=MENUDYN00171\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie mouvement d'entr&eacute;e</a>"+
    "<a class=\"btn btn-primary pull-right btn-small mx-2\" href=\"module.jsp?but=caisse/mvt/mvtCaisse-saisie-sortie.jsp&currentMenu=MENUDYN00173\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie mouvement de sortie</a>"
    );
    String[] enteteRecap = {"","Nombres","Somme des Entr&eacute;es de caisse","Somme des Sorties de caisse"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

%>
<script>
    function changerEtat(){
        document.formRecherche.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="formRecherche" id="formRecherche">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        <div class="row">
            <div class="col-lg-12 ">
                    <div class="col-md-2 nopadding" style="margin-top: 12px">
                        <div class="d-flex" style="align-items: end;gap: 8px;">
                            <div class="form-input w-100">
                                <label for="etat" class="input-label">&Eacute;tat</label>
                                <select name="etat" id="etat" class="form-control" onchange="changerEtat()">
                                    <%
                                        for(int i=0; i<etatAffiche.length; i++){
                                            String selected = "";
                                            if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase(etatPasse[i])==0){
                                                selected = "selected";
                                            }
                                    %>
                                    <option value="<%=etatPasse[i]%>" <%=selected%>><%=etatAffiche[i]%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                    </div>
            </div>
        </div>
        </form>
        <div class="row">
            <div class="col-md-12">
        <%
            out.println(pr.getTableauRecap().getHtml());%>
            </div>
        </div>
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



