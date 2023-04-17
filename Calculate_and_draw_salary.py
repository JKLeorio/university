import pandas as pd
import matplotlib.pyplot as plt

def calculate_bonus(hours : int) -> int:
    if hours >= 5:
        return 0.15
    elif hours >= 3:
        return 0.12
    else:
        return 0
    
def generate_bonus(data : object) -> object:
    table = pd.DataFrame(data)
    bonus_multiplier = table['time'].apply(calculate_bonus)
    table['bonus_salary'] = table['salary'] * bonus_multiplier
    table['final_salary'] = table['salary'] + table['bonus_salary']
    print(table.to_markdown())
    print(f"\n{'-' * 30}\nfull salary", table["final_salary"].sum())
    return table

def draw_time_bar(table : object) -> None:
    plt.bar(table["name"], table["time"])
    plt.xlabel("name")
    plt.ylabel("spent time")
    plt.title("overtime statistics")

    plt.show()

def draw_pie_chart(table : object) -> None:
    plt.pie(table['salary'], labels=table['name'], autopct='%1.1f%%')
    plt.title("workers salary")
    plt.show()
    
def main() -> None:
    data = {
    'second_name': ['Владимиров', 'Понасенком', 'Сидоров','Карданов'],
    'name':        ['Владимир', 'Артём', 'Алексей','Азот'],
    'job':         ['Инженер', 'Инженер проектировщик', 'Тестировщик изделий', 'Фрезеровщик'],
    'salary':      [45000, 60000, 33000, 38000],
    'time':        [5, 7, 2, 6]
    }
    table = generate_bonus(data)
    draw_time_bar(table)
    draw_pie_chart(table)
    
if __name__ == "__main__":
    main()