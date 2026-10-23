package paie.edition;

import java.util.List;

import paie.conge.CongeDroitCPL;
import paie.pointage.PointageHeureSup;
import utils.ConstantePaie;

public class MappingElementPaie {

    private double salaireDeBase;
    private double salaireDuMoisArrondi;
    private double irsa;
    private double cnaps;
    private double ostie;
    private double prime;
    private double totalRetenues;
    private double totalGains;
    private double indemnite;
    private double netAPayerArrondi;
    private double allocation;
    private double heureReels;
    private double congePaye;
    private double totalHeureSup;
    private double congeDroit;
    private double avanceExceptionnelle;
    private double avanceSalaire;
    private double avanceTotale;
    private double avanceGain;
    private double valHeureSup;
    private double abattement;
    private double totalHS;
    private double hsNuit;
    private double hsDim;
    private double hsFerie;

    // --- NEW ATTRIBUTES ---
    private double heureSupp30Ni;
    private double heureSupp30I;
    private double heureSupp50Ni;
    private double heureSupp50I;

    public MappingElementPaie()
    { }

    public static MappingElementPaie getValeurElementDePaie(List<PaieEditionEltpaie> listePaieEditionElementPaie) {
        try {
            MappingElementPaie mapping = new MappingElementPaie();
            mapping.setHeureReels(listePaieEditionElementPaie.get(0).getHeureNormal());

            if (!listePaieEditionElementPaie.isEmpty() && listePaieEditionElementPaie.get(0).getIdpersonnel() != null) {
                String idPersonnel = listePaieEditionElementPaie.get(0).getIdpersonnel();
                CongeDroitCPL congeDroitCPL = CongeDroitCPL.getCongeDroitPersonnel(idPersonnel);
                mapping.setCongeDroit(congeDroitCPL.getConge());
            }

            for (PaieEditionEltpaie element : listePaieEditionElementPaie) {
                String idElement = element.getIdelementpaie();

                if (idElement == null) continue;

                if (idElement.equals(ConstantePaie.idSalaireBasePaie)) {
                    mapping.setSalaireDeBase(element.getDroits());
                } else if (idElement.equals(ConstantePaie.idIrsaPaie)) {
                    mapping.setIrsa(element.getRetenues());
                } else if (idElement.equals(ConstantePaie.idCnapsPaie)) {
                    mapping.setCnaps(element.getRetenues());
                } else if (idElement.equals(ConstantePaie.idIndemnitePaie)) {
                    mapping.setIndemnite(element.getDroits());
                } else if (idElement.equals(ConstantePaie.idAllocationPaie)) {
                    mapping.setAllocation(element.getDroits());
                } else if (idElement.equals(ConstantePaie.idOstiePaie)) {
                    mapping.setOstie(element.getRetenues());
                } else if (idElement.equals(ConstantePaie.idPrimePaie)) {
                    mapping.setPrime(element.getDroits());
                } else if (idElement.equals(ConstantePaie.idNetAPayerArrondis)) {
                    mapping.setNetAPayerArrondi(element.getDroits());
                } else if (idElement.equals(ConstantePaie.idTotalGainsPaie)) {
                    mapping.setTotalGains(element.getDroits());
                } else if (idElement.equals(ConstantePaie.idTotalRetenuesPaie)) {
                    mapping.setTotalRetenues(element.getRetenues());
                }
                // conge
                else if (idElement.equals("PR000061")) {
                    mapping.setCongePaye(element.getDroits());
                }
                else if (idElement.equals("PR0000115")) {
                    mapping.setAvanceGain(element.getDroits());
                }
                // avance
                else if(idElement.equals(ConstantePaie.idAvanceExceptionnelle)) {
                    mapping.setAvanceExceptionnelle(element.getRetenues());
                }
                else if(idElement.equals(ConstantePaie.idAvanceSurSalaire)) {
                    mapping.setAvanceSalaire(element.getRetenues());
                }
                else if(idElement.equals("PR0000229")) {
                    mapping.setValHeureSup(element.getDroits());
                }
                else if(idElement.equals("PR000181")) {
                    mapping.setAbattement(element.getDroits());
                }
                else if(idElement.equals("PR0000221")) {
                    mapping.setHsNuit(element.getDroits());
                }
                else if(idElement.equals("PR0000222")) {
                    mapping.setHsFerie(element.getDroits());
                }
                else if(idElement.equals("PR0000223")) {
                    mapping.setHsDim(element.getDroits());
                }

                // --- NEW MAPPINGS FOR HEURE SUPP ---
                else if (idElement.equals("PR0000130")) {
                    mapping.setHeureSupp30Ni(element.getDroits());
                }
                else if (idElement.equals("PR0000130I")) {
                    mapping.setHeureSupp30I(element.getDroits());
                }
                else if (idElement.equals("PR0000150")) {
                    mapping.setHeureSupp50Ni(element.getDroits());
                }
                else if (idElement.equals("PR0000150I")) {
                    mapping.setHeureSupp50I(element.getDroits());
                }else if (idElement.equals("PR0000130A")) {
                    mapping.setCongePaye(element.getDroits());
                }

                // Calculate Total HS (Updated with new fields)
                mapping.setTotalHS(
                        mapping.getHsNuit() +
                                mapping.getHsFerie() +
                                mapping.getHsDim() +
                                mapping.getValHeureSup() +
                                mapping.getHeureSupp30Ni() +
                                mapping.getHeureSupp30I() +
                                mapping.getHeureSupp50Ni() +
                                mapping.getHeureSupp50I()
                );

                mapping.setAvanceTotale(mapping.getAvanceExceptionnelle() + mapping.getAvanceSalaire());
            }
            return mapping;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public static String getCategorieQualif(String fonction) {
        if (fonction == null) return "HC";
        if (fonction.equalsIgnoreCase("Chauffeur")) {
            return "3A-GP2";
        } else if (fonction.equalsIgnoreCase("TECHNICIEN DE SURFACE")) {
            return "1A-GP2";
        } else if (
                fonction.equalsIgnoreCase("Chargée Admin & Financier") ||
                        fonction.equalsIgnoreCase("Manager Qualité") ||
                        fonction.equalsIgnoreCase("Manager Plateau Junior") ||
                        fonction.equalsIgnoreCase("Superviseur")
        ) {
            return "HC";
        } else if (
                fonction.equalsIgnoreCase("Agent Call") ||
                        fonction.equalsIgnoreCase("Agent BPO") ||
                        fonction.equalsIgnoreCase("Télévendeur")
        ) {
            return "4B-GP3";
        } else if (fonction.equalsIgnoreCase("Assistant Polyvalente") || fonction.equalsIgnoreCase("Agent CALL")) {
            return "4A-GP3";
        } else {
            return "HC";
        }
    }

    // --- GETTERS AND SETTERS ---

    // New Attributes
    public double getHeureSupp30Ni() { return heureSupp30Ni; }
    public void setHeureSupp30Ni(double heureSupp30Ni) { this.heureSupp30Ni = heureSupp30Ni; }

    public double getHeureSupp30I() { return heureSupp30I; }
    public void setHeureSupp30I(double heureSupp30I) { this.heureSupp30I = heureSupp30I; }

    public double getHeureSupp50Ni() { return heureSupp50Ni; }
    public void setHeureSupp50Ni(double heureSupp50Ni) { this.heureSupp50Ni = heureSupp50Ni; }

    public double getHeureSupp50I() { return heureSupp50I; }
    public void setHeureSupp50I(double heureSupp50I) { this.heureSupp50I = heureSupp50I; }

    // Existing Attributes
    public double getCongeDroit() { return congeDroit; }
    public void setCongeDroit(double congeDroit) { this.congeDroit = congeDroit; }
    public double getTotalHeureSup() { return totalHeureSup; }
    public void setTotalHeureSup(double totalHeureSup) { this.totalHeureSup = totalHeureSup; }
    public double getSalaireDuMoisArrondi() { return salaireDuMoisArrondi; }
    public void setSalaireDuMoisArrondi(double salaireDuMoisArrondi) { this.salaireDuMoisArrondi = salaireDuMoisArrondi; }
    public double getCongePaye() { return congePaye; }
    public void setCongePaye(double congePaye) { this.congePaye = congePaye; }
    public double getOstie() { return ostie; }
    public void setOstie(double ostie) { this.ostie = ostie; }
    public double getSalaireDeBase() { return salaireDeBase; }
    public void setSalaireDeBase(double salaireDeBase) { this.salaireDeBase = salaireDeBase; }
    public double getIrsa() { return irsa; }
    public void setIrsa(double irsa) { this.irsa = irsa; }
    public double getCnaps() { return cnaps; }
    public void setCnaps(double cnaps) { this.cnaps = cnaps; }
    public double getPrime() { return prime; }
    public void setPrime(double prime) { this.prime = prime; }
    public double getTotalRetenues() { return totalRetenues; }
    public void setTotalRetenues(double totalRetenues) { this.totalRetenues = totalRetenues; }
    public double getTotalGains() { return totalGains; }
    public void setTotalGains(double totalGains) { this.totalGains = totalGains; }
    public double getSalaierDuMoisArrondi() { return salaireDuMoisArrondi; }
    public void setSalaierDuMoisArrondi(double salaireDuMoisArrondi) { this.salaireDuMoisArrondi = salaireDuMoisArrondi; }
    public double getIndemnite() { return indemnite; }
    public void setIndemnite(double indemnite) { this.indemnite = indemnite; }
    public double getNetAPayerArrondi() { return netAPayerArrondi; }
    public void setNetAPayerArrondi(double netAPayerArrondi) { this.netAPayerArrondi = netAPayerArrondi; }
    public double getAllocation() { return allocation; }
    public void setAllocation(double allocation) { this.allocation = allocation; }
    public void setHeureReels(double heureReels) { this.heureReels = heureReels; }
    public double getHeureReels() { return this.heureReels; }
    public double getAvanceExceptionnelle() { return avanceExceptionnelle; }
    public void setAvanceExceptionnelle(double avanceExceptionnelle) { this.avanceExceptionnelle = avanceExceptionnelle; }
    public double getAvanceSalaire() { return avanceSalaire; }
    public void setAvanceSalaire(double avanceSalaire) { this.avanceSalaire = avanceSalaire; }
    public double getAvanceTotale() { return avanceTotale; }
    public void setAvanceTotale(double avanceTotale) { this.avanceTotale = avanceTotale; }
    public double getAvanceGain() { return avanceGain; }
    public void setAvanceGain(double avanceGain) { this.avanceGain = avanceGain; }
    public double getValHeureSup() { return valHeureSup; }
    public void setValHeureSup(double valHeureSup) { this.valHeureSup = valHeureSup; }
    public double getAbattement() { return abattement; }
    public void setAbattement(double abattement) { this.abattement = abattement; }
    public double getTotalHS() { return totalHS; }
    public void setTotalHS(double totalHS) { this.totalHS = totalHS; }
    public double getHsNuit() { return hsNuit; }
    public void setHsNuit(double hsNuit) { this.hsNuit = hsNuit; }
    public double getHsDim() { return hsDim; }
    public void setHsDim(double hsDim) { this.hsDim = hsDim; }
    public double getHsFerie() { return hsFerie; }
    public void setHsFerie(double hsFerie) { this.hsFerie = hsFerie; }

    @Override
    public String toString() {
        return "MappingElementPaie {" +
                "salaireDeBase=" + salaireDeBase +
                ", netAPayer=" + netAPayerArrondi +
                ", totalHS=" + totalHS +
                '}';
    }
}