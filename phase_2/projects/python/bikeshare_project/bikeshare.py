import time
import pandas as pd
import numpy as np

"""
Project:    Explore Bikeshare Data
Student:    Juan Sanchez
Submission: #1
"""

CITY_DATA = {
    "chicago": "chicago.csv",
    "new york city": "new_york_city.csv",
    "washington": "washington.csv",
}


MONTHS = ["january", "february", "march", "april", "may", "june"]


def get_city():
    """Get the city input from the user"""
    # get user input for city (chicago, new york city, washington). HINT: Use a while loop to handle invalid inputs
    message = "Select a city to analyze. Available Choices: Chicago, New York City, Washington\nEnter your city choice here: "
    while True:
        city = input(message).lower()
        print()
        if city in CITY_DATA.keys():
            break
        else:
            print("Please enter a valid city name.")

    return city


def get_month_filter():
    """Get month filter from the user.
    Returns:
        (str) Month entered by the user
    """
    # get user input for month (all, january, february, ... , june)
    month_selection_prompt = (
        "Type one of these months: {}\nEnter your month here:  ".format(", ".join([x.capitalize() for x in MONTHS]))
    )

    while True:
        filter_by_month = input(
            "Do you want to filter by month? \nType 'yes' to filter by month or 'no' to use all data: "
        ).lower()
        if filter_by_month == "yes":
            # ask the user for the desired month to filter by
            print("Select the month to filter the data by.")

            while True:
                month = input(month_selection_prompt).lower()
                print()
                if month not in MONTHS:
                    print("Please enter a valid month.")
                    continue
                else:
                    break
            break
        elif filter_by_month == "no":
            month = "all"
            break
        else:
            print("Invalid answer. Please type a valid answer.")
    return month


def get_day_filter():
    # get user input for day of week (all, monday, tuesday, ... sunday)
    days = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
    ]
    days_selection_prompt = (
        "Please type one of the following days {} \nEnter your day here:  ".format(
            ", ".join(days)
        )
    )

    while True:
        filter_by_day = input(
            "Do you want to filter by day? \nPlease type 'yes' to filter by day or 'no' to use all data: "
        ).lower()
        if filter_by_day == "yes":
            print("Select the day to filter the data by.")
            # loop until the user provides a valid day
            while True:
                day = input(days_selection_prompt).lower()
                if day.capitalize() not in days:
                    print("Please enter a valid day")
                else:
                    break
            break
        elif filter_by_day == "no":
            day = "all"
            break
        else:
            print("Invalid selection. Please try again.")
    return day


def get_filters():
    """
    Asks user to specify a city, month, and day to analyze.

    Returns:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    """
    print("Hello! Let's explore some US bikeshare data!")
    print()
    # get city from User
    city = get_city()

    # get month from user
    month = get_month_filter()

    # get day from user
    day = get_day_filter()

    print("-" * 40)
    return city, month, day


def load_data(city, month, day):
    """
    Loads data for the specified city and filters by month and day if applicable.

    Args:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    Returns:
        df - Pandas DataFrame containing city data filtered by month and day
    """
    # load data file into a dataframe
    df = pd.read_csv(CITY_DATA[city])

    # convert the Start Time column to datetime
    df["Start Time"] = pd.to_datetime(df["Start Time"])

    # extract month and day of week from Start Time to create new columns
    df["month"] = df["Start Time"].dt.month
    df["day_of_week"] = df["Start Time"].dt.day_name()

    # filter by month if applicable
    if month != "all":
        # use the index of the months list to get the corresponding int
        months = ["january", "february", "march", "april", "may", "june"]
        month = months.index(month) + 1

        # filter by month to create the new dataframe
        df = df[df["month"] == month]

    # filter by day of week if applicable
    if day != "all":
        # filter by day of week to create the new dataframe
        df = df[df["day_of_week"] == day.title()]

    return df


def time_stats(df):
    """Displays statistics on the most frequent times of travel."""

    print("\nCalculating The Most Frequent Times of Travel...\n")
    start_time = time.time()

    # convert Start Time to datetime
    df["Start Time"] = pd.to_datetime(df["Start Time"])

    # create a column with the most common month
    df["month"] = df["Start Time"].dt.month
    # find the most common month
    popular_month = df["month"].mode()[0]

    # create a column the most common day of week
    df["day_of_week"] = df["Start Time"].dt.day_name()
    # find the most common day
    popular_day = df["day_of_week"].mode()[0]

    # create a column with the most common start hour
    df["hour"] = df["Start Time"].dt.hour
    # find the most common hour
    popular_hour = df["hour"].mode()[0]

    # print time stats
    print(
        " Most popular month: {}\n Most popular day:   {}\n Most popular hour:  {}".format(
            popular_month, popular_day, popular_hour
        )
    )

    print("\nThis took %s seconds." % (time.time() - start_time))
    print("-" * 40)


def station_stats(df):
    """Displays statistics on the most popular stations and trip."""

    print("\nCalculating The Most Popular Stations and Trip...\n")
    start_time = time.time()

    # display most commonly used start station
    popular_start_station = df["Start Station"].mode()[0]
    print("The most popular start station is: {}".format(popular_start_station))

    # display most commonly used end station
    popular_end_station = df["End Station"].mode()[0]
    print("The most popular end station is: {}".format(popular_end_station))

    # display most frequent combination of start station and end station trip
    df["station_trip_combination"] = df["Start Station"] + \
        " - " + df["End Station"]
    # calculate the most frequent station combination
    popular_station_combination = df["station_trip_combination"].mode()[0]
    print(
        "The most popular start-end station combination is: {}".format(
            popular_station_combination
        )
    )

    print("\nThis took %s seconds." % (time.time() - start_time))
    print("-" * 40)


def trip_duration_stats(df):
    """Displays statistics on the total and average trip duration."""

    print("\nCalculating Trip Duration...\n")
    start_time = time.time()

    # display total travel time
    total_travel_time = sum(df["Trip Duration"])
    print("Total travel time:   {}".format(total_travel_time))

    # display mean travel time
    travel_mean = df["Trip Duration"].mean()
    print("Average travel time: {:.2f}".format(travel_mean))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print("-" * 40)


def user_stats(df):
    """Displays statistics on bikeshare users."""

    print("\nCalculating User Stats...\n")
    start_time = time.time()

    # Display counts of user types
    print("User type count:")
    user_type_count = df["User Type"].value_counts().to_string()
    print(user_type_count)

    # Display counts of gender
    print("\nGender count:")
    if "Gender" in df.columns:
        gender_count = df.value_counts("Gender").to_string()
        print(gender_count)
    else:
        print("Gender data is not available on the data set.")

    # Display earliest, most recent, and most common year of birth
    # Check if the Birth Year column is in the df
    print("\nBirth Year Stats:")
    if "Birth Year" in df.columns:
        message = " Earliest birth year:    {}\n Most recent birth year: {}\n Most common birth year: {}"
        min_birth_year = df["Birth Year"].min()
        max_birth_year = df["Birth Year"].max()
        most_common_birth_year = df["Birth Year"].mode()[0]

        print(
            message.format(
                int(min_birth_year), int(max_birth_year), int(
                    most_common_birth_year)
            )
        )
    else:
        print("Birth Year data is not available on the data set.")

    print("\nThis took %s seconds." % (time.time() - start_time))
    print("-" * 40)


def get_raw_data(df):
    """Prints batch of 5 rows of raw data from the dataframe"""
    start = 0
    end = start + 5
    df_size = df.shape[0]
    message = "\nDo you want see five rows of raw data? Enter yes or no: "
    
    while True:
        print_raw_data = input(message)
        if print_raw_data.lower() == "yes":
            if end > df_size:
                print(df.iloc[start:df_size])
                print("\nYou have requested all the elements of the raw data.")
                break
            else:
                print(df.iloc[start:end])
                start = end
                end = start + 5
                message = ("\nDo you want to see five more rows? Enter yes or no: ")
        elif print_raw_data.lower() == 'no':
            break
        else:
            continue
    print("-" * 40)


def main():
    while True:
        city, month, day = get_filters()

        df = load_data(city, month, day)

        message = (
            "\nPerforming calculation on bike share data from using the following data:"
        )
        message += "\nCity  : {:<15}".format(city.upper())
        message += "\nMonth : {:<15}".format(month.capitalize())
        message += "\nDay   : {:<15}".format(day.capitalize())

        print(message)
        print("-" * 40)
        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df)
        get_raw_data(df)

        restart = input("\nWould you like to restart? Enter yes or no.\n")
        if restart.lower() != "yes":
            break


if __name__ == "__main__":
    main()
