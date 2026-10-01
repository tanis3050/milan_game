using Ink.Runtime;
using UnityEngine;

public class GameState : MonoBehaviour
{
    private Story story;

    // --------------------------------------------------
    // INITIALIZATION
    // --------------------------------------------------

    public void Initialize(Story inkStory)
    {
        story = inkStory;
    }

    // --------------------------------------------------
    // INTEGER ACCESS
    // --------------------------------------------------

    public int GetInt(string variableName)
    {
        if (story == null)
        {
            Debug.LogError("GameState has not been initialized.");
            return 0;
        }

        object value = story.variablesState[variableName];

        if (value is int intValue)
            return intValue;

        Debug.LogWarning(
            $"Ink variable '{variableName}' is not an integer."
        );

        return 0;
    }

    public void SetInt(string variableName, int value)
    {
        if (story == null)
            return;

        story.variablesState[variableName] = value;
    }

    public void ChangeInt(string variableName, int amount)
    {
        SetInt(
            variableName,
            GetInt(variableName) + amount
        );
    }

    // --------------------------------------------------
    // GAME VARIABLES
    // --------------------------------------------------

    public int Money => GetInt("money");
    public int Day => GetInt("day");
    public int TotalMinutes => GetInt("total_minutes");

    public int Sleep => GetInt("sleep");
    public int Hunger => GetInt("hunger");
    public int Social => GetInt("social");
    public int Stress => GetInt("stress");

    // --------------------------------------------------
    // TIME DISPLAY
    // --------------------------------------------------

    public string GetTimeString()
    {
        int minutesInDay = TotalMinutes % (24 * 60);

        int hour = minutesInDay / 60;
        int minute = minutesInDay % 60;

        string suffix = hour >= 12 ? "PM" : "AM";

        int displayHour = hour % 12;

        if (displayHour == 0)
            displayHour = 12;

        return $"{displayHour}:{minute:00} {suffix}";
    }
}