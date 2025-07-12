# R Tutorial: Cleaning and Filtering Data from Qualtrics Surveys, and Creating New Variables in the Dataframe

By Jean-Eude

**R version used**: 4.0.3 (2020-10-10) — "Bunny-Wunnies Freak Out"  
**Latest update**: July 12, 2025

---

Hi everyone! If you've worked with Qualtrics survey exports before, you've probably noticed that the datasets they produce can look pretty messy and repetitive across projects.

In this tutorial, I’m sharing the R code I regularly use—along with clear explanations—for:
- Cleaning and filtering Qualtrics survey data
- Creating new variables from existing ones using functions and logical conditions

As with most things in R, there are many ways to accomplish the same task. These are just the methods that work well for me, and I hope they'll be useful for you too—so you don’t have to spend hours digging through forums for basic tasks like I once did.

---

### 💡 Pro tip:
You can save yourself a lot of cleaning work by taking full advantage of **Qualtrics survey design features**. That includes:
- Naming your variables clearly
- Recoding response values properly
- Using export tags (especially for matrix-type questions)

Doing this can help you export a cleaner, more “refined” dataset straight from Qualtrics.

But since that's not always possible (especially if you're working with legacy data), this guide focuses on cleaning **unrefined** exports. If your data is already tidy, you’ll still find the code useful—just skip the steps you don’t need.

---

If you have any questions, suggestions, or just want to share feedback, feel free to connect with me!

Thanks for stopping by,  
**Jean-Eude**
