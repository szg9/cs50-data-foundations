class Jar:
    def __init__(self, capacity=12):
        if not isinstance(capacity, int) or capacity < 0:
            raise ValueError("Invalid input.")

        self.capacity = capacity
        self.size = 0

    def __str__(self):
        return "🍪" * self.size

    def deposit(self, n):
        if n < 0:
            raise ValueError("Invalid input.")

        if (self.size + n) > self.capacity:
            raise ValueError("Not enough free space in jar.")

        self.size += n

    def withdraw(self, n):
        if n <= 0:
            raise ValueError("Invalid input.")

        if (self.size - n) < 0:
            raise ValueError("Not enough cookie in jar.")

        self.size -= n

    @property
    def capacity(self):
        return self._capacity

    @property
    def size(self):
        return self._size

    @capacity.setter
    def capacity(self, capacity):
        self._capacity = capacity

    @size.setter
    def size(self, size):
        self._size = size