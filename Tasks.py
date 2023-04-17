#Задача 1
def calculate_rectangle(a : float, b : float) -> float:
	S = a * b
	P = 2 * (a + b)
	return {"Площадь":S,"Периметр":P}


#Задача 2
def get_max(nums : list[float]) -> float:
	return f"Максимум = {max(nums)}"


#Задача 3
def sum_from_one_to_k(k : int) -> float:
	S = 0
	for n in range(1, k+1):
		S += (9 * n) / (n ** 2 + n + 1)
	return f"Сумма результатов функции с 1 до k элементов = {S}"

def main() -> None:
	print(f"Задача 1\n{calculate_rectangle(4.5 , 6.5)}")
	print(f"Задача 2\n{get_max([-5,3,4])}")
	print(f"Задача 3\n{sum_from_one_to_k(56)}")

if __name__ == '__main__':
	main()