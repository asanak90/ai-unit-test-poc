using PaymentService;

namespace PaymentService.Tests;

public class PaymentProcessorTests
{
    [Fact]
    public void ProcessPayment_ShouldReturnTrue_WhenAmountIsValid()
    {
        // Arrange
        var processor = new PaymentProcessor();

        // Act
        var result = processor.ProcessPayment(500);

        // Assert
        Assert.True(result);
    }
}