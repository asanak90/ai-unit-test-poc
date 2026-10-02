namespace PaymentService;

public class PaymentService
{
    private readonly IPaymentRepository _repository;

    public PaymentService(IPaymentRepository repository)
    {
        _repository = repository;
    }

    public bool ProcessPayment(int paymentId)
    {
        var payment = _repository.GetPayment(paymentId);

        if (payment == null)
            return false;

        if (payment.Amount <= 0)
            return false;

        if (payment.Amount > 10000)
            return false;    

        return true;
    }
}