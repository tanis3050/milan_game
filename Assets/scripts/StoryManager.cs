using System.Text;
using Ink.Runtime;
using Ink.UnityIntegration;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class StoryManager : MonoBehaviour
{
    [Header("Ink")]
    [SerializeField] private InkFile inkFile;

    [Header("Game State")]
    [SerializeField] private GameState gameState;

    [Header("Story UI")]
    [SerializeField] private TMP_Text locationText;
    [SerializeField] private TMP_Text storyText;

    [Header("HUD")]
    [SerializeField] private TMP_Text dayText;
    [SerializeField] private TMP_Text timeText;
    [SerializeField] private TMP_Text moneyText;

    [Header("Choices")]
    [SerializeField] private Button[] choiceButtons;

    private Story story;

    // --------------------------------------------------
    // START
    // --------------------------------------------------

    public void StartStory()
    {
        if (inkFile == null)
        {
            Debug.LogError("No InkFile assigned.");
            return;
        }

        // Ink Unity Integration 2.0
        story = new Story(inkFile.storyJson);

        story.onError += HandleInkError;

        gameState.Initialize(story);

        ContinueStory();
    }

    // --------------------------------------------------
    // CONTINUE STORY
    // --------------------------------------------------

    public void ContinueStory()
    {
        if (story == null)
            return;

        StringBuilder text = new StringBuilder();

        // Continue until Ink reaches choices or the end
        while (story.canContinue)
        {
            string line = story.Continue().Trim();

            if (!string.IsNullOrEmpty(line))
            {
                if (text.Length > 0)
                    text.Append("\n\n");

                text.Append(line);
            }
        }

        storyText.text = text.ToString();

        UpdateHUD();
        DisplayChoices();
        UpdateLocation();
    }


    // --------------------------------------------------
    // CHOICES
    // --------------------------------------------------

    private void DisplayChoices()
    {
        // Hide/reset all buttons
        for (int i = 0; i < choiceButtons.Length; i++)
        {
            choiceButtons[i].gameObject.SetActive(false);
            choiceButtons[i].onClick.RemoveAllListeners();
        }

        // No choices = story has ended
        if (story.currentChoices.Count == 0)
        {
            return;
        }

        for (int i = 0; i < story.currentChoices.Count; i++)
        {
            if (i >= choiceButtons.Length)
            {
                Debug.LogWarning(
                    "More Ink choices exist than available buttons."
                );

                break;
            }

            int choiceIndex = i;

            Button button = choiceButtons[i];

            TMP_Text buttonText =
                button.GetComponentInChildren<TMP_Text>();

            if (buttonText != null)
            {
                buttonText.text =
                    story.currentChoices[i].text;
            }

            button.gameObject.SetActive(true);

            button.onClick.AddListener(() =>
            {
                ChooseChoice(choiceIndex);
            });
        }
    }

    private void ChooseChoice(int choiceIndex)
    {
        story.ChooseChoiceIndex(choiceIndex);

        ContinueStory();
    }

    // --------------------------------------------------
    // HUD
    // --------------------------------------------------

    private void UpdateHUD()
    {
        if (dayText != null)
            dayText.text = $"Day {gameState.Day}";

        if (timeText != null)
            timeText.text = gameState.GetTimeString();

        if (moneyText != null)
            moneyText.text = $"{gameState.Money}. rs";
    }

    // --------------------------------------------------
    // LOCATION
    // --------------------------------------------------

    public void SetLocation(string location)
    {
        if (locationText != null)
            locationText.text = location;
    }
private void UpdateLocation()
{
    if (story == null)
        return;

    string location = story.variablesState["location"] as string;

    if (string.IsNullOrEmpty(location))
        return;
    SetLocation(location);
}

    // --------------------------------------------------
    // INK ERROR HANDLING
    // --------------------------------------------------

    private void HandleInkError(
        string message,
        Ink.ErrorType type)
    {
        if (type == Ink.ErrorType.Warning)
            Debug.LogWarning(message);
        else
            Debug.LogError(message);
    }

    // --------------------------------------------------
    // ACCESS TO STORY
    // --------------------------------------------------

    public Story GetStory()
    {
        return story;
    }
}