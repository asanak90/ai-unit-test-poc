namespace PaymentService;

public interface IPaymentRepository
{
    Payment? GetPayment(int paymentId);
}