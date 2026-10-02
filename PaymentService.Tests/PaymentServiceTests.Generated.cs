#nullable enable

using Moq;
using PaymentService;
using Xunit;

namespace PaymentService.Tests
{
    public class PaymentServiceGeneratedTests
    {
        [Fact]
        public void ProcessPayment_PaymentDoesNotExist_ReturnsFalse()
        {
            // Arrange
            var mockRepository = new Mock<IPaymentRepository>();
            mockRepository.Setup(r => r.GetPayment(It.IsAny<int>()))
                .Returns((Payment?)null);

            var paymentService = new PaymentService(mockRepository.Object);

            // Act
            var result = paymentService.ProcessPayment(1);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void ProcessPayment_PaymentAmountIsZero_ReturnsFalse()
        {
            // Arrange
            var mockRepository = new Mock<IPaymentRepository>();
            mockRepository.Setup(r => r.GetPayment(It.IsAny<int>()))
                .Returns(new Payment { Amount = 0 });

            var paymentService = new PaymentService(mockRepository.Object);

            // Act
            var result = paymentService.ProcessPayment(1);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void ProcessPayment_PaymentAmountIsNegative_ReturnsFalse()
        {
            // Arrange
            var mockRepository = new Mock<IPaymentRepository>();
            mockRepository.Setup(r => r.GetPayment(It.IsAny<int>()))
                .Returns(new Payment { Amount = -10 });

            var paymentService = new PaymentService(mockRepository.Object);

            // Act
            var result = paymentService.ProcessPayment(1);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void ProcessPayment_PaymentAmountIsGreaterThan10000_ReturnsFalse()
        {
            // Arrange
            var mockRepository = new Mock<IPaymentRepository>();
            mockRepository.Setup(r => r.GetPayment(It.IsAny<int>()))
                .Returns(new Payment { Amount = 10001 });

            var paymentService = new PaymentService(mockRepository.Object);

            // Act
            var result = paymentService.ProcessPayment(1);

            // Assert
            Assert.False(result);
        }
    }
}