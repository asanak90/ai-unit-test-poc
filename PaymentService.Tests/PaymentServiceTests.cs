using Moq;
using PaymentService;

namespace PaymentService.Tests;

public class PaymentServiceTests
{
    [Fact]
    public void ProcessPayment_ShouldReturnTrue_WhenPaymentIsValid()
    {
        // Arrange
        var repository = new Mock<IPaymentRepository>();

        repository
            .Setup(x => x.GetPayment(1))
            .Returns(new Payment
            {
                Id = 1,
                Amount = 500
            });

        var service = new PaymentService(repository.Object);

        // Act
        var result = service.ProcessPayment(1);

        // Assert
        Assert.True(result);
    }
}