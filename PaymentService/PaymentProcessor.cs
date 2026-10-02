namespace PaymentService;

public class PaymentProcessor
{
    public bool ProcessPayment(decimal amount)
    {
        if (amount <= 0)
            return false;

        if (amount > 10000)
            return false;

        return true;
    }
}