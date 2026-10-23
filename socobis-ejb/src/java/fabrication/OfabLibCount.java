package fabrication;

public class OfabLibCount extends Of {
    private double nb;
    public OfabLibCount() throws Exception {
        setNomTable("OFABLIBCOUNT");
    }

    public double getNb() {
        return nb;
    }

    public void setNb(int nb) {
        this.nb = nb;
    }
}
