<%@page import="caisse.VirementIntraCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    VirementIntraCaisseCpl t = new VirementIntraCaisseCpl();
    t.setNomTable("VirementIntraCaisseCpl");
    String etat = request.getParameter("etat");
    if(etat == null) etat = "";
    t.setNomTable( t.getNomTable().concat(etat) );
    String listeCrt[] = {"id","designation","daty","montant","idCaisseDepartLib","idCaisseArriveLib"};
    String listeInt[] = {"daty", "montant"};
    String libEntete[] = {"id","designation","daty","idCaisseDepartLib","idCaisseArriveLib","montant", "etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setNpp(50);
    pr.setTitre("virements intra-caisse");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/virementIntraCaisse/virementIntraCaisse-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Ref.");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idCaisseDepartLib").setLibelle("Tr&eacute;sorerie de d&eacute;part");
    pr.getFormu().getChamp("idCaisseArriveLib").setLibelle("Tr&eacute;sorerie d'arriv&eacute;e");
    pr.getFormu().getChamp("montant1").setLibelle("Montant min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant min");
    String[] colSomme = {"montant"};
    pr.creerObjetPage(libEntete, colSomme);
    Map<String,String> lienTab=new HashMap();
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    String classe = "caisse.VirementIntraCaisse";
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=caisse/virementIntraCaisse/virementIntraCaisse-liste.jsp&classe=" + classe  + "&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=caisse/virementIntraCaisse/virementIntraCaisse-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=caisse/virementIntraCaisse/virementIntraCaisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableauRecap().setLibelleAffiche(new String[]{"", "Nombre", "Somme des montants"});
    //Definition des libelles � afficher
    String libEnteteAffiche[] = {"Ref.","d&eacute;signation","date","Tr&eacute;sorerie de D&eacute;part","Tr&eacute;sorerie d'Arriv&eacute;e","montant", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatAffiche = {"Tous","Cr&eacute;&eacute;(s)","Valid&eacute;(s)","Annul&eacute;(s)"};
    String[] etatPasse = {"","_cree","_valider","_annule"};
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=caisse/virementIntraCaisse/virementIntraCaisse-saisie.jsp\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un virement intra tr&eacute;sorerie</a>"
    );
    String[] enteteRecap = {"","Nombres","Somme montant"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
%>

<script>
    function changerEtat() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">

            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

            <div class="row col-md-12 nopadding">
                <div class="col-md-4 nopadding">
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
        </form>


        <div class="row">
            <div class="col-md-12 nopadding">
                <%
                    out.println(pr.getTableauRecap().getHtml());
                %>
            </div>
        </div>

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



