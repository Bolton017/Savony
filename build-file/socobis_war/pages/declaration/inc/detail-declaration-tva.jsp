<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="declaration.ImprimerDeclaration" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="declaration.DeclarationTva" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="declaration.DeclarationTvaLib" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{ 
    ImprimerDeclaration o = new ImprimerDeclaration();
    o.setNomTable("IMPRIMEDECLARATIONLIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"numero","rubrique","montant"};
    ImprimerDeclaration[] enc_mere = null;
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        String id = request.getParameter("id");
        enc_mere = (ImprimerDeclaration[]) CGenUtil.rechercher(new ImprimerDeclaration(), null, null, null,"");
        DeclarationTvaLib[] decls = (DeclarationTvaLib[]) CGenUtil.rechercher(new DeclarationTvaLib(), null, null, null," AND ID='"+id+"'");
        if(decls.length <1){
            throw new Exception("Pas de declaration pour : "+id);
        }
        System.err.println("Declaration du : "+decls[0].getDatydebut()+" au "+decls[0].getDatyfin());
        DeclarationTva dec = new DeclarationTva(decls[0].getDatydebut(),decls[0].getDatyfin());
        HashMap<String, ImprimerDeclaration> res = dec.getDonnees();
        for (int j = 0; j < enc_mere.length; j++) {
            ImprimerDeclaration calcule = res.get(enc_mere[j].getId());
            if(calcule != null){
                enc_mere[j].setMontant(calcule.getMontant());
                //enc_mere[j].setMontantadeclarer(calcule.getMontant()*(calcule.getTaux()/100));
            }
        }
    }


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    double total = 0;
    // Alimenter le tableau avec les données calculées si disponibles
    if(enc_mere != null && enc_mere.length > 0){
        pr.getTableau().setData(enc_mere);
        total = enc_mere[enc_mere.length-2].getMontant();
        pr.getTableau().transformerDataString();
    }

    String[] libEnteteAffiche = {"Num&eacute;ro","Rubrique","Montant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <h3>Net à payer : <b><%= Utilitaire.formaterAr(total) %> Ar</b></h3>
    <%
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        } else{ %>
            <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
