using UnityEngine;

public class GameManager : MonoBehaviour
{
    [SerializeField] private GameState gameState;
    [SerializeField] private StoryManager storyManager;

    private void Start()
    {
        StartGame();
    }

    public void StartGame()
    {
        if (gameState == null)
        {
            Debug.LogError("GameState reference missing.");
            return;
        }

        if (storyManager == null)
        {
            Debug.LogError("StoryManager reference missing.");
            return;
        }

        storyManager.StartStory();
    }
}